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

type Font struct {
	Family       string
	Variants     []string
	Subsets      []string
	Version      string
	LastModified string
	Files        map[string]string
	Category     string
	Kind         string
}

type FontList struct {
	Kind  string
	Items []Font
}

func getEnv() string {
	_, filename, _, ok := runtime.Caller(0)
	if !ok {
		log.Fatalln("could not recover information from stack frame 0")
	}

	envFile := path.Join(path.Dir(filename), ".env")
	err := godotenv.Load(envFile)
	if err != nil {
		log.Fatalf("could not read env file '%s'", envFile)
	}

	env := os.Getenv("SECRET_GOOGLE_FONTS_API_KEY")
	if env == "" {
		log.Fatalf("Environment variable '%s' is empty. Must have value", "SECRET_GOOGLE_FONTS_API_KEY")
	}
	return env
}

func fetch(env string) []byte {
	url := fmt.Sprintf("https://www.googleapis.com/webfonts/v1/webfonts?key=%s", env)
	resp, err := http.Get(url)
	if err != nil {
		log.Fatalln(err)
	}

	// close response body to ensure no resource leaks
	// defer causes this to be exec at the end of the function
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}

	return body
}

func doJson(body []byte) FontList {
	fontList := FontList{}
	err := json.Unmarshal(body, &fontList)
	if err != nil {
		log.Fatalln("unmarshal unsuccessfull")
	}

	return fontList
}

func main() {
	env := getEnv()
	body := fetch(env)
	fontList := doJson(body)

	for _, item := range fontList.Items {
		fmt.Printf("%+v\n", item)

	}
}
