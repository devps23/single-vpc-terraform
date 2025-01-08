# module "frontend" {
#   depends_on = [module.backend]
#   source = "./modules/app"
#   component = "frontend"
#   instance_type=var.instance_type
#   env = var.env
#   zone_id     = var.zone_id
#   vault_token = var.vault_token
# }
# module "backend" {
#   depends_on = [module.mysql]
#   source = "./modules/app"
#   component = "backend"
#   instance_type=var.instance_type
#   env = var.env
#   zone_id = var.zone_id
#   vault_token = var.vault_token
# }
# module "mysql" {
#   source = "./modules/app"
#   component = "mysql"
#   instance_type=var.instance_type
#   env = var.env
#   zone_id = var.zone_id
#   vault_token = var.vault_token
# }
module "vpc"{
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  env = var.env

}
