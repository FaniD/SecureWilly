package main

import (
  "fmt"
  "os"
)

func main() {

  // This will be the output profile for the specific service
  var service, new_path string
  service = os.Args[1]
  new_path =  "../parser_output/profiles/" + service + "/version_1"

  // In static parser profile names are used, not paths.
  // If paths are used here I have to search for paths too. Not fixed yet.

  f, err := os.Create(new_path)
  if err != nil {
    fmt.Println(err)
    f.Close()
    return
  }

  _, err = fmt.Fprintln(f, "#include <tunables/global>\n")
  _, err = fmt.Fprintln(f, "profile " + service + "_profile flags=(attach_disconnected,mediate_deleted) {\n")
  _, err = fmt.Fprintln(f,"\tfile,  #This rule is needed so that I can work with files (create files/directories, copy, etc)")
  _, err = fmt.Fprintln(f, "\t/var/lib/docker/* r,")
  _, err = fmt.Fprintln(f, "\tdeny ptrace (readby, tracedby),\n}")

  // Output
  err = f.Close()
    if err != nil {
        fmt.Println(err)
        return
    }

}
