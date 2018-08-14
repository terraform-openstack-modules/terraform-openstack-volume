resource "openstack_blockstorage_volume_v2" "vol" {
  count             = "${var.count}"
  region            = "${var.region}"
  availability_zone = "${var.availability_zone}"
  name              = "${element(var.instance_name, count.index)}${format("vol-%02d", count.index+1)}"
  size              = "${var.size}"
}

resource "openstack_compute_volume_attach_v2" "va" {
  count       = "${var.count}"
  region      = "${var.region}"
  instance_id = "${element(var.instance_id, count.index)}" 
  volume_id   = "${element(openstack_blockstorage_volume_v2.vol.*.id, count.index)}"
}
