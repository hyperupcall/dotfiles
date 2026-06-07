use std::env;
use std::fs;
use std::io::Write;
use std::os::unix::process::CommandExt;
use std::path::Path;
use std::process::{exit, Command, Stdio};
use std::io;

fn find_source_file() -> Result<String, String> {
	// Check for OCaml files.
	let ocaml_files: Vec<_> = fs::read_dir(".")
		.map_err(|e| e.to_string())?
		.filter_map(|entry| entry.ok())
		.map(|entry| entry.path())
		.filter(|path| path.extension().and_then(|s| s.to_str()) == Some("ml"))
		.collect();
	if !ocaml_files.is_empty() {
		if ocaml_files.len() > 1 {
			return Err("Error: Multiple OCaml files found".to_string());
		}
		return Ok(ocaml_files[0].to_string_lossy().to_string());
	}

	// Check for C++ files.
	let cpp_files: Vec<_> = fs::read_dir(".")
		.map_err(|e| e.to_string())?
		.filter_map(|entry| entry.ok())
		.map(|entry| entry.path())
		.filter(|path| path.extension().and_then(|s| s.to_str()) == Some("cpp"))
		.collect();
	if !cpp_files.is_empty() {
		if cpp_files.len() > 1 {
			return Err("Error: Multiple C++ files found".to_string());
		}
		return Ok(cpp_files[0].to_string_lossy().to_string());
	}

	// Check for Java files.
	let java_files: Vec<_> = fs::read_dir(".")
		.map_err(|e| e.to_string())?
		.filter_map(|entry| entry.ok())
		.map(|entry| entry.path())
		.filter(|path| path.extension().and_then(|s| s.to_str()) == Some("java"))
		.collect();
	if !java_files.is_empty() {
		if java_files.len() > 1 {
			return Err("Error: Multiple Java files found".to_string());
		}
		return Ok(java_files[0].to_string_lossy().to_string());
	}

	// Check for Python files.
	let py_files: Vec<_> = fs::read_dir(".")
		.map_err(|e| e.to_string())?
		.filter_map(|entry| entry.ok())
		.map(|entry| entry.path())
		.filter(|path| path.extension().and_then(|s| s.to_str()) == Some("py"))
		.collect();
	if !py_files.is_empty() {
		if py_files.len() > 1 {
			return Err("Error: Multiple Python files found".to_string());
		}
		return Ok(py_files[0].to_string_lossy().to_string());
	}

	Err("Error: No source file found".to_string())
}

fn compile_file(filepath: &str, contest_compilation: bool) -> Result<(), String> {
	let path = Path::new(filepath);
	let ext = path.extension().and_then(|s| s.to_str()).unwrap_or("");
	let exe_name = path.file_stem().and_then(|s| s.to_str()).unwrap_or("a.out");

	match ext {
		"ml" => {
			let mut args = vec!["-o", exe_name, filepath];
			if !contest_compilation {
				args.insert(0, "-g");
			}
			let status = Command::new("ocamlopt")
				.args(&args)
				.status()
				.map_err(|e| format!("Failed to execute ocamlopt: {}", e))?;

			if status.success() {
				Ok(())
			} else {
				Err("OCaml compilation failed".to_string())
			}
		}
		"cpp" => {
			let mut args = vec!["-x", "c++", "-std=gnu++20"];
			if contest_compilation {
				args.push("-O2");
				args.push("-static");
			} else {
				args.append(&mut vec!["-Wall", "-Wextra", "-Wshadow", "-Wfloat-equal", "-Wconversion", "-Wlogical-op", "-Wshift-overflow=2", "-Wduplicated-cond", "-Wfatal-errors"]);
				args.append(&mut vec!["-DISDEBUG", "-D_GLIBCXX_DEBUG"]);
				args.append(&mut vec!["-fsanitize=undefined,address",  "-fstack-protector", "-fno-sanitize-recover"]);
				args.push("-g3");
				args.push("-fsanitize=address,undefined");
				args.push("-DISDEBUG");

			}
			args.push(filepath);
			args.push("-o");
			args.push(exe_name);

			let status = Command::new("g++")
				.args(&args)
				.status()
				.map_err(|e| format!("Failed to execute gcc: {}", e))?;

			if status.success() {
				Ok(())
			} else {
				Err("C++ compilation failed".to_string())
			}
		}
		"java" => {
			let mut args = vec![
				"--source",
				"21",
				"-encoding",
				"UTF-8",
				"-sourcepath",
				".",
				"-d",
				".",
			];
			if !contest_compilation {
				args.push("-g");
			}
			args.push(filepath);

			let status = Command::new("javac")
				.args(&args)
				.status()
				.map_err(|e| format!("Failed to execute javac: {}", e))?;

			if status.success() {
				Ok(())
			} else {
				Err("Java compilation failed".to_string())
			}
		}
		"py" => Ok(()),
		_ => Err(format!("Error: Unknown file type: .{}", ext)),
	}
}

fn find_test_files() -> Vec<(String, Option<String>)> {
	let mut tests = Vec::new();

	if let Ok(entries) = fs::read_dir(".") {
		let mut inputs: Vec<String> = entries
			.filter_map(|entry| entry.ok())
			.map(|entry| entry.file_name().to_string_lossy().to_string())
			.filter(|name| name.starts_with("in") && name[2..].chars().next().map_or(false, |c| c.is_ascii_digit()))
			.collect();

		inputs.sort();

		for input in inputs {
			let suffix = &input[2..];
			let output = format!("out{}", suffix);
			let output_opt = if Path::new(&output).exists() { Some(output) } else { None };
			tests.push((input, output_opt));
		}
	}

	tests
}

fn run_tests(filepath: &str) -> Result<(), String> {
	let path = Path::new(filepath);
	let ext = path.extension().and_then(|s| s.to_str()).unwrap_or("");
	let exe_name = path.file_stem().and_then(|s| s.to_str()).unwrap_or("a.out");
	let exe_path = format!("./{}", exe_name);

	let tests = find_test_files();

	if tests.is_empty() {
		println!("No test files found (looking for in1, in2, ... files)");
		return Ok(());
	}

	println!(
		"Running {} {}\n",
		tests.len(),
		if tests.len() == 1 { "test" } else { "tests" }
	);
	for (test_num, (input_file, output_file)) in tests.iter().enumerate() {
		println!("\x1B[1;4mTEST {}\x1B[0m", test_num + 1);

		let input_data =
			fs::read(&input_file).map_err(|e| format!("Failed to read {}: {}", input_file, e))?;
		let expected_output: Option<String> = match output_file {
			Some(f) => Some(fs::read_to_string(f).map_err(|e| format!("Failed to read {}: {}", f, e))?),
			None => None,
		};

		let output = match ext {
			"ml" | "cpp" => {
				let mut child = Command::new(&exe_path)
					.stdin(Stdio::piped())
					.stdout(Stdio::piped())
					.spawn()
					.map_err(|e| format!("Failed to execute {}: {}", exe_name, e))?;

				if let Some(mut stdin) = child.stdin.take() {
					stdin
						.write_all(&input_data)
						.map_err(|e| format!("Failed to write to stdin: {}", e))?;
				}

				let output = child
					.wait_with_output()
					.map_err(|e| format!("Failed to wait for {}: {}", exe_name, e))?;

				String::from_utf8_lossy(&output.stdout).to_string()
			}
			"java" => {
				let classname = path
					.file_stem()
					.and_then(|s| s.to_str())
					.ok_or("Invalid Java filename")?;

				let mut child = Command::new("java")
					.args(&[
						"-Dfile.encoding=UTF-8",
						"-XX:+UseSerialGC",
						"-Xss64m",
						classname,
					])
					.stdin(Stdio::piped())
					.stdout(Stdio::piped())
					.spawn()
					.map_err(|e| format!("Failed to execute java: {}", e))?;

				if let Some(mut stdin) = child.stdin.take() {
					stdin
						.write_all(&input_data)
						.map_err(|e| format!("Failed to write to stdin: {}", e))?;
				}

				let output = child
					.wait_with_output()
					.map_err(|e| format!("Failed to wait for java: {}", e))?;

				String::from_utf8_lossy(&output.stdout).to_string()
			}
			"py" => {
				let mut child = Command::new("pypy3")
					.arg(filepath)
					.stdin(Stdio::piped())
					.stdout(Stdio::piped())
					.spawn()
					.map_err(|e| format!("Failed to execute pypy3: {}", e))?;

				if let Some(mut stdin) = child.stdin.take() {
					stdin
						.write_all(&input_data)
						.map_err(|e| format!("Failed to write to stdin: {}", e))?;
				}

				let output = child
					.wait_with_output()
					.map_err(|e| format!("Failed to wait for pypy3: {}", e))?;

				String::from_utf8_lossy(&output.stdout).to_string()
			}
			_ => return Err(format!("Error: Cannot execute file type: .{}", ext)),
		};

		io::stderr().flush().unwrap();
		io::stdout().flush().unwrap();

		let trimmed_output = output.trim_end();
		println!("--- \x1b[3mActual\x1b[0m");
		if trimmed_output.is_empty() {
			println!("\x1b[3mN/A\x1b[0m");
		} else {
			println!("{}", trimmed_output);
		}
		println!("--- \x1b[3mExpected\x1b[0m");
		match &expected_output {
			Some(expected) => println!("{}", expected.trim_end()),
			None => println!("\x1b[3mN/A\x1b[0m"),
		}
		println!("---");

		if test_num != tests.len() - 1 {
			println!();
		}
	}

	Ok(())
}

fn main() {
	let args: Vec<String> = env::args().collect();
	let mut test = false;
	let mut execute = false;
	let mut contest = false;
	let mut filepath: Option<String> = None;
	for arg in args.iter().skip(1) {
		match arg.as_str() {
			"-h" => {
				println!("Usage: cptest [OPTIONS] [FILE]");
				println!();
				println!("OPTIONS:");
				println!("  -c    Contest compilation");
				println!("  -t    Run all tests");
				println!("  -x    Execute the compiled program");
				println!("  -h    Show this help message");
				println!();
				println!("FILE:");
				println!("  Source file to compile (auto-detected if not specified)");
				println!("  Supports C++, Java, Python, and OCaml");
				exit(0);
			}
			"-t" => test = true,
			"-x" => execute = true,
			"-c" => contest = true,
			s if !s.starts_with('-') => {
				if filepath.is_none() {
					filepath = Some(s.to_string());
				}
			}
			unknown => {
				eprintln!("Error: Unrecognized argument: {}", unknown);
				eprintln!("Use -h for usage information.");
				exit(1);
			}
		}
	}

	if test && execute {
		eprintln!("Error: Cannot use both -t and -x flags together");
		exit(1);
	}

	let filepath = match filepath {
		Some(f) => f,
		None => match find_source_file() {
			Ok(f) => f,
			Err(e) => {
				eprintln!("{}", e);
				exit(1);
			}
		},
	};

	if !Path::new(&filepath).exists() {
		eprintln!("Error: File not found: {}", filepath);
		exit(1);
	}

	println!("Compiling {}", filepath);
	if let Err(e) = compile_file(&filepath, contest) {
		eprintln!("{}", e);
		exit(1);
	}

	if test {
		if let Err(e) = run_tests(&filepath) {
			eprintln!("{}", e);
			exit(1);
		}
	}

	if execute {
		println!("Executing {}", filepath);
		println!("---");

		let path = Path::new(&filepath);
		let ext = path.extension().and_then(|s| s.to_str()).unwrap_or("");
		let exe_name = path.file_stem().and_then(|s| s.to_str()).unwrap_or("a.out");
		let exe_path = format!("./{}", exe_name);

		let err = match ext {
			"ml" | "cpp" => Command::new(&exe_path).exec(),
			"java" => {
				let classname = path.file_stem().and_then(|s| s.to_str()).unwrap_or("Main");

				Command::new("java")
					.args(&[
						"-Dfile.encoding=UTF-8",
						"-XX:+UseSerialGC",
						"-Xss64m",
						classname,
					])
					.exec()
			}
			"py" => Command::new("pypy3").arg(&filepath).exec(),
			_ => {
				eprintln!("Error: Cannot execute file type: .{}", ext);
				exit(1);
			}
		};

		eprintln!("Failed to exec: {}", err);
		exit(1);
	}
}
