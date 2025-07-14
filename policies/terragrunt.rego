package terragrunt.validation

deny[msg] {
  not file_exists("root.hcl")
  msg := "❌ Falta el archivo obligatorio 'root.hcl' en el proyecto Terragrunt."
}

file_exists(name) {
  some i
  input.files[i] == name
}