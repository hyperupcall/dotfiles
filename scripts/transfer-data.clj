#!/usr/bin/env bb
;; Transfer data between machines via an encrypted removable drive.
;;
;; Babashka rewrite of transfer-data.sh. It saves selected files and
;; directories to a removable drive (encrypting the sensitive ones with a
;; password) and restores them on another machine.

(ns transfer-data
	(:require
		[babashka.fs :as fs]
		[babashka.process :as p]
		[cheshire.core :as json]
		[clojure.java.io :as io]
		[clojure.string :as str]))

(def home (System/getProperty "user.home"))
(def dotfiles-dir (fs/path home ".dotfiles"))
(def setup-sh (fs/path dotfiles-dir "config" "setup.sh"))
(def setup-private-sh (fs/path dotfiles-dir "config" "setup-private.sh"))
(def bootstrap-sh (fs/path dotfiles-dir "bootstrap-linux.sh"))

;;; Output

(defn- fd-tty? [fd]
	(zero? (:exit (p/sh ["sh" "-c" (str "test -t " fd)] {:out :inherit :err :inherit}))))

(def ^:private tty? (memoize fd-tty?))

(defn- should-print-color? [fd]
	(cond
		(contains? (System/getenv) "NO_COLOR") false
		(contains? #{"1" "2" "3"} (System/getenv "FORCE_COLOR")) true
		(= "0" (System/getenv "FORCE_COLOR")) false
		(= "dumb" (System/getenv "TERM")) false
		:else (tty? fd)))

(defn print-info [msg]
	(if (should-print-color? 1)
		(println (str "\u001b[1;32mInfo:\u001b[0m " msg))
		(println (str "Info: " msg))))

(defn print-warn [msg]
	(binding [*out* *err*]
		(if (should-print-color? 2)
			(println (str "\u001b[1;33mWarn:\u001b[0m " msg))
			(println (str "Warn: " msg)))))

(defn print-fatal [msg]
	(binding [*out* *err*]
		(if (should-print-color? 2)
			(println (str "\u001b[1;35mFatal:\u001b[0m " msg))
			(println (str "Fatal: " msg)))))

(defn die [msg]
	(print-fatal msg)
	(System/exit 1))

;;; Prompts

(defn- read-one-char []
	(let [c (.read *in*)]
		(if (neg? c) \newline (char c))))

(defn prompt-one-char
	"Read a single character without requiring the user to press Enter.
	Mirrors bash's `read -N1`: the character is echoed and a newline is
	printed afterwards."
	[prompt]
	(print prompt)
	(flush)
	(if-not (tty? 0)
		(let [c (read-one-char)]
			(println)
			c)
		(let [saved (str/trim (:out (p/sh ["stty" "-g"] {:in :inherit})))]
			(try
				(p/sh ["stty" "-icanon" "min" "1" "time" "0"] {:in :inherit})
				(let [c (read-one-char)]
					(println)
					c)
				(finally
					(p/sh ["stty" saved] {:in :inherit}))))))

(defn prompt-yes-no [prompt]
	(let [c (prompt-one-char prompt)]
		(or (= c \y) (= c \Y))))

(defn prompt-line [prompt]
	(print prompt)
	(flush)
	(or (read-line) ""))

;;; Mount points

(defn list-mount-options
	"Print candidate mount points and return them in order."
	[]
	(let [res (p/sh ["lsblk" "--list" "--json" "--output"
	                 "ID,FSSIZE,FSTYPE,MODEL,PATH,NAME,LABEL,MOUNTPOINT"])]
		(when-not (zero? (:exit res))
			(die (str "lsblk failed with exit code " (:exit res))))
		(let [devices (->> (:blockdevices (json/parse-string (:out res) true))
		                   (filter (fn [device]
		                             (when-let [mountpoint (:mountpoint device)]
		                               (re-find #"^/mnt|/media|/run" mountpoint)))))]
			(vec
				(map-indexed
					(fn [index device]
						(let [mountpoint (:mountpoint device)
						      id (or (:id device) "")]
							(println (str "#" index "\n"
							              "  ID: " (subs id 0 (min 50 (count id))) "...\n"
							              "  MOUNTPOINT: " mountpoint " (" (:path device) ")\n"
							              "  SIZE: " (:fssize device) " (" (:fstype device) ")"))
							mountpoint))
					devices)))))

;;; XDG directories

(defn load-xdg-dirs
	"Source setup.sh and read the XDG base directory variables."
	[]
	(let [script (str "source \"" setup-sh "\" >/dev/null 2>&1; "
	                  "printf '%s\\n' \"$XDG_CONFIG_HOME\" \"$XDG_DATA_HOME\" \"$XDG_STATE_HOME\"")
	      lines (str/split-lines (:out (p/sh ["bash" "-c" script])))]
		(if (and (>= (count lines) 3) (every? #(not (str/blank? %)) (take 3 lines)))
			(subvec (vec lines) 0 3)
			[(or (System/getenv "XDG_CONFIG_HOME") "")
			 (or (System/getenv "XDG_DATA_HOME") "")
			 (or (System/getenv "XDG_STATE_HOME") "")])))

;;; Encryption

(defn- gpg-args [homedir passphrase-file]
	["gpg" "--homedir" homedir "--no-keyring" "--batch" "--yes"
	 "--pinentry-mode" "loopback" "--passphrase-file" passphrase-file
	 "--cipher-algo" "AES256" "--no-symkey-cache" "--armor"])

(defn- create-passphrase-file
	"Write the passphrase to a 0600 temporary file for gpg's
	--passphrase-file. Babashka cannot hand gpg an arbitrary extra file
	descriptor the way the shell's `3<<<\"$password\"` does."
	[password]
	(let [f (fs/create-temp-file {:prefix "transfer-data-" :suffix "-passphrase"})]
		(fs/write-lines f [password])
		(str f)))

(defn- check-procs [& procs]
	(doseq [proc procs]
		(let [res @proc]
			(when-not (zero? (:exit res))
				(print-warn (str (first (:cmd res)) " failed with exit code " (:exit res)))))))

(defn encrypt-dir [src-dir dest-file passphrase-file homedir]
	(let [parent (str (fs/parent src-dir))
	      basename (str (fs/file-name src-dir))]
		(fs/create-dirs (fs/parent dest-file))
		(let [tar-proc (p/process ["tar" "-C" parent "-c" (str "./" basename)]
		                          {:out :pipe :err :inherit})
		      gpg-proc (p/process tar-proc
		                          (conj (gpg-args homedir passphrase-file) "--symmetric")
		                          {:out (io/file (str dest-file)) :err :inherit})]
			(check-procs gpg-proc tar-proc))))

(defn decrypt-to-dir [src-file dest-dir passphrase-file homedir]
	(let [parent (str (fs/parent dest-dir))
	      gpg-proc (p/process (conj (gpg-args homedir passphrase-file) "--decrypt")
	                          {:in (io/file (str src-file)) :out :pipe :err :inherit})
	      tar-proc (p/process gpg-proc ["tar" "-C" parent "-x"] {:err :inherit})]
		(check-procs tar-proc gpg-proc)))

(defn decrypt-setup-private [src-file dest-file passphrase-file homedir]
	(let [gpg-proc (p/process (conj (gpg-args homedir passphrase-file) "--decrypt" (str src-file))
	                          {:out :pipe :err :inherit})
	      tar-proc (p/process gpg-proc ["tar" "-xO"]
	                          {:out (io/file (str dest-file)) :err :inherit})]
		(check-procs tar-proc gpg-proc)))

(defn remove-broken-symlinks
	"Remove top-level broken symlinks, which cannot be copied over."
	[directory]
	(doseq [entry (fs/list-dir directory)]
		(let [name (str (fs/file-name entry))]
			;; Bash globs do not match dotfiles.
			(when (and (not (str/starts-with? name "."))
			           (fs/sym-link? entry)
			           (not (fs/exists? entry)))
				(fs/delete entry)))))

;;; Save / restore

(defn- generate-password []
	(let [rng (java.security.SecureRandom.)
	      chars (vec (map char (range 33 127)))]
		(apply str (repeatedly 14 (fn [] (nth chars (.nextInt rng (count chars))))))))

(defn save [dirpath paths-encrypt paths]
	(p/shell ["sudo" "rm" "-rf" dirpath])
	(p/shell ["sudo" "mkdir" "-p" dirpath])
	(let [user (System/getenv "USER")]
		(p/shell ["sudo" "chown" (str user ":" user) dirpath]))

	(fs/copy (fs/path *file*) (fs/path dirpath "transfer-data.clj") {:replace-existing true})
	(fs/copy bootstrap-sh (fs/path dirpath "bootstrap.sh") {:replace-existing true})
	;; Like the original `chmod +x`, do not abort if the file system does not
	;; support POSIX permissions.
	(p/sh ["chmod" "+x" (str (fs/path dirpath "transfer-data.clj")) (str (fs/path dirpath "bootstrap.sh"))])

	(let [password (generate-password)
	      temp-gnupg (str (fs/create-temp-dir {:suffix "-gnupg"}))
	      passphrase-file (create-passphrase-file password)]
		(try
			(print-info (str "Password: " password))

			(when (prompt-yes-no "Save password to _data/pw.txt? [y/n] ")
				(fs/create-dirs dirpath)
				(spit (str (fs/path dirpath "pw.txt")) (str password "\n"))
				(print-info (str "Password written to " dirpath "/pw.txt")))

			(doseq [[name directory] paths-encrypt]
				(let [encrypted-file (str dirpath "/" name ".tar.gz.asc")]
					(if (or (str/blank? directory) (not (fs/exists? directory)))
						(print-warn (str "Skipping " name ": '" directory "' does not exist"))
						(do
							(print-info (str "Encrypting " directory " to " encrypted-file))
							(encrypt-dir directory encrypted-file passphrase-file temp-gnupg)))))

			(doseq [[name directory] paths]
				(let [src (str dirpath "/" name ".tar.gz")]
					(if (or (str/blank? directory) (not (fs/exists? directory)))
						(print-warn (str "Skipping " name ": '" directory "' does not exist"))
						(do
							(print-info (str "Copying " directory " to " src))
							(fs/create-dirs (fs/parent src))
							;; The directory may contain symlinks, so copy as a tarball so it
							;; is always preserved, no matter the file system.
							(p/shell ["tar" "-C" directory "-cf" src "."])))))
			(finally
				(fs/delete-if-exists passphrase-file)))))

(defn restore [dirpath paths-encrypt paths]
	(let [pw-file (fs/path dirpath "pw.txt")
	      password (if (fs/regular-file? pw-file)
	                 (do
	                   (print-info (str "Using password from " pw-file))
	                   (str/trim-newline (slurp (str pw-file))))
	                 (prompt-line "Password? "))
	      temp-gnupg (str (fs/create-temp-dir {:suffix "-gnupg"}))
	      passphrase-file (create-passphrase-file password)]
		(try
			(doseq [[name directory] paths-encrypt]
				;; Mirrors the original check, which is currently a no-op.
				(when-not (= directory "scripts_hidden")
					(let [encrypted-file (str dirpath "/" name ".tar.gz.asc")
					      proceed? (if (fs/exists? directory)
					                 (do
					                   (print-warn (str "File or directory " directory " already exists"))
					                   (if (prompt-yes-no "Remove? [y/n] ")
					                     (do (fs/delete-tree directory) true)
					                     (do (print-warn (str "Skipping directory " directory)) false)))
					                 (if (prompt-yes-no (str "Copy to " directory "? [y/n] "))
					                   true
					                   (do (print-warn (str "Skipping directory " directory)) false)))]
						(when proceed?
							(print-info (str "Decrypting " encrypted-file " to " directory))
							(fs/create-dirs (fs/parent directory))
							(decrypt-to-dir encrypted-file directory passphrase-file temp-gnupg)
							(when (fs/directory? directory)
								(remove-broken-symlinks directory))))))

			(doseq [[name directory] paths]
				(let [src (str dirpath "/" name ".tar.gz")
				      proceed? (if (fs/exists? directory)
				                 (do
				                   (print-warn (str "File or directory " directory " already exists"))
				                   (if (prompt-yes-no "Remove? [y/n] ")
				                     (do (fs/delete-tree directory) true)
				                     (do (print-warn (str "Skipping directory " directory)) false)))
				                 (if (prompt-yes-no (str "Copy to " directory "? [y/n] "))
				                   true
				                   (do (print-warn (str "Skipping directory " directory)) false)))]
					(when proceed?
						(print-info (str "Extracting " src " to " directory))
						(fs/create-dirs directory)
						;; The directory may contain symlinks, so copy as a tarball so it
						;; is always preserved, no matter the file system.
						(p/shell ["tar" "-C" directory "-xf" src]))))
			(finally
				(fs/delete-if-exists passphrase-file)))))

;;; Entry point

(defn main []
	(let [[xdg-config-home xdg-data-home xdg-state-home] (load-xdg-dirs)
	      mode (loop []
	             (let [m (prompt-line "Which mode? (save|restore): ")]
	               (if (contains? #{"save" "restore"} m) m (recur))))
	      options (conj (list-mount-options) "__manual__")]

		(println (str "#" (dec (count options)) "\n  MOUNTPOINT: (specify manually)"))

		(let [answer (loop []
		               (let [a (prompt-line "Choose location for temporary files: ")
		                     n (parse-long a)]
		                 (if (and n (<= 0 n) (< n (count options)))
		                   n
		                   (recur))))
		      device-path (nth options answer)
		      device-path (if (= device-path "__manual__")
		                    (prompt-line "Enter directory path: ")
		                    device-path)
		      dirpath (str (str/replace device-path #"/$" "") "/_data")]

			(when-not (fs/regular-file? setup-private-sh)
				(let [temp-gnupg-dir (str (fs/create-temp-dir {:suffix "-gnupg"}))
				      password (str/trim-newline (slurp (str (fs/path dirpath "pw.txt"))))
				      passphrase-file (create-passphrase-file password)]
					(try
						(decrypt-setup-private (str dirpath "/setup_private_sh.tar.gz.asc")
						                       (str setup-private-sh)
						                       passphrase-file
						                       temp-gnupg-dir)
						(finally
							(fs/delete-if-exists passphrase-file)))))

			(let [paths-encrypt
			      [["gnupg" (str home "/.gnupg")]
			       ["ssh" (str home "/.ssh")]
			       ["history" (str xdg-state-home "/history")]
			       ["syncthing" (str xdg-state-home "/syncthing")]
			       ["borgkeys" (str xdg-config-home "/borg/keys")]
			       ["basalt_token" (str xdg-config-home "/basalt/token")]
			       ["woof_token" (str xdg-data-home "/woof/token")]
			       ;; ["scripts_hidden" private-scripts-hidden]
			       ["setup_private_exec_sh" (str home "/.dotfiles/config/setup-private-exec.sh")]
			       ["setup_private_py" (str home "/.dotfiles/config/setup-private.py")]
			       ["setup_private_sh" (str home "/.dotfiles/config/setup-private.sh")]
			       ["dotfiles_git_exclude" (str home "/.dotfiles/.git/info/exclude")]]
			      paths
			      [["libreoffice" (str xdg-config-home "/libreoffice/4/user")]
			       ["fonts" (str xdg-data-home "/fonts")]
			       ["dbeaver" (str xdg-data-home "/DBeaverData/workspace6/General/Scripts")]
			       ["ankiuserdata" (str xdg-data-home "/Anki2/Default User")]
			       ["ankiaddons" (str xdg-data-home "/Anki2/addons21")]
			       ["applicationsdir" (str home "/Other/Application Data")]
			       ["devresources" (str home "/.devhidden")]]]
				(case mode
					"save" (save dirpath paths-encrypt paths)
					"restore" (restore dirpath paths-encrypt paths)
					(die (str "Invalid mode: " mode))))

			(when (prompt-yes-no (str "Done! Would you like to unmount " (str (fs/parent dirpath)) "? "))
				(p/sh ["sudo" "umount" (str (fs/parent dirpath))] {:dir home}))

			(print-info "Exiting."))))

(try
	(main)
	(catch Exception e
		(print-fatal (str "Command failed: " (.getMessage e)))
		(System/exit 1)))
