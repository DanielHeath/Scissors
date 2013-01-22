package main

import (
	"fmt"
	"github.com/DanielHeath/scissors-go/encryption"
	"net/http"
	"net/url"
	"os"
	_ "strconv"
)

func main() {
	port := os.Getenv("PORT")
	clientName := os.Getenv("CLIENT_NAME")
	secret := os.Getenv("SECRET")
	loginUri := os.Getenv("CLIENT_LOGIN_URI")
	loginFormUri := os.Getenv("CLIENT_LOGIN_FORM_URI")
	app := encryption.NewApp(clientName, secret)

	handler := func(w http.ResponseWriter, r *http.Request) {
		if r.Method != "POST" {
			fmt.Fprintf(w, "POST only")
		} else {
			// We're serving html, not the default text
			w.Header().Add("content-type", "text/html; charset=UTF-8")

			identity := r.FormValue("identity")
			password := r.FormValue("password")
			appdata := r.FormValue("appdata")

			location := "/"

			if (identity == "John") && (password == "Smith") {
				bodyFmt := `
        {
          "user" : {
            "ident" : "John",
            "random_other" : "property"
          },
          "appdata" : "%s"
        }
        `
				body := fmt.Sprintf(bodyFmt, appdata)
				token := url.QueryEscape(app.Sign(body))
				escaped_body := url.QueryEscape(body)

				location = fmt.Sprintf("%s?signed_token=%s&signed_body=%s", loginUri, token, escaped_body)
			} else {
				location = fmt.Sprintf("%s?%s", loginFormUri, r.URL.Query())
			}
			fmt.Println(location)

			w.Header().Set("Location", location)
			w.Header().Set("Cache-Control", "no-cache")
			w.WriteHeader(http.StatusFound)

		}
	}
	http.HandleFunc("/", handler)
	fmt.Println(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}
