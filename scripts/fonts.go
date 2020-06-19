///bin/true; exec /usr/bin/env go run "$0" "$@"

package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path"
	"runtime"

	"github.com/joho/godotenv"
)

func main() {
	type Font struct {
		kind         string
		family       string
		category     string
		variants     []string
		subsets      []string
		version      string
		lastModified string
		files        map[string]string
	}

	type FontsResponse struct {
		kind  string
		items []Font
	}

	fontsResponseObject := FontsResponse{}

	_, filename, _, ok := runtime.Caller(0)
	if !ok {
		log.Fatalln("could not")
	}

	envFile := path.Join(path.Dir(filename), ".env")
	log.Println(envFile)
	godotenv.Load(envFile)

	env := os.Getenv("SECRET_GOOGLE_FONTS_API_KEY")
	if env == "" {
		log.Fatalln("key blanks")
	}

	url := fmt.Sprintf("https://www.googleapis.com/webfonts/v1/webfonts?key=%s", env)
	resp, err := http.Get(url)
	if err != nil {
		log.Fatalln(err)
	}

	// forgetting to close the response body can cause
	// resource leaks
	// defer causes this to be exec at the end of the function
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}

	log.Println(string(body))
	json.Unmarshal([]byte(body), &fontsResponseObject)

	log.Println(fontsResponseObject.kind)
}
