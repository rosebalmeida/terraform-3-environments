module "resources" {
  source = "./resources"
  providers = {
    aws = aws
  }
}