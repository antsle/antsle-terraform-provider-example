resource "antsle_antlets" "antlet1" {
  dname = "antlet1"
  template = "Fedora.lxc"
  ram = 1024
  cpu = 1
  antlet_num = 33
  zpool_name = "antlets"
  compression = "lz4"
}
