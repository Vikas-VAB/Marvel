provider "google" {
  credentials = file("credentials.json")
  project     = "playground-s-11-2976525d"
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_project_iam_custom_role" "vabRole123" {
  role_id     = "vabRoleTest"
  title       = "My Custom Role"
  permissions = ["storage.objects.create","storage.buckets.get"]
}

resource "google_compute_instance" "test2" {
  name         = "test2"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"

  tags = ["gcp"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }


  network_interface {
    subnetwork= google_compute_subnetwork.test_subnetwork1.self_link

    access_config {
      // Ephemeral IP
    }
  }
  metadata_startup_script = file("user_data.sh")
}

resource "google_compute_network" "vpc_network1" {
   name = "vpc-network1"
   mtu  = 1500
   auto_create_subnetworks = false
  }
  resource "google_compute_subnetwork" "test_subnetwork1" {
   name          = "test-subnetwork1"
   ip_cidr_range = "10.2.0.0/16"
   region        = "us-central1"
   network       = google_compute_network.vpc_network1.id
}

resource "google_storage_bucket" "vabbucket1" {
  name          = "vabbucket1"
  location      = "US"
  project       = "playground-s-11-2976525d"
  storage_class = "standard"

}

resource "google_storage_bucket_object" "index_html" {
  name   = "index.html"
  source = "/terraform/demo1/index.html"
  bucket = google_storage_bucket.vabbucket1.id
}


resource "google_compute_firewall" "modified" {
  name    = "test1-firewall"
  network = google_compute_network.vpc_network1.id

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22"]
  }
}

