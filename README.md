<h1>Using the antMan REST API with Terraform</h1>
<div style="color:#a00">
  <p class="note">NOTE: The antMan REST API is experimental with no guarantees and may change at any time.</p>
</div>

#Manage a Single Node
This is an example setup to manage one server (node) with Terraform. It's recommended you familiarize yourself with the workings of the antMan API first. To do that, read the article <a href="https://docs.antsle.com/rest/">"Rest API"</a> and / or check out the swagger documentation on your server. The swagger documentation can be found under 'myantsle'.local:3000/swagger-ui.

##Installing the provider
The Antsle Terraform plugin is based on the <a href="https://github.com/dikhan/terraform-provider-openapi" target="_blank">Terraform OpenAPI Provider</a>. You can download the <a href="">sample project here</a> to get started.

To install the binary, simply place it into your plugin directory - usually located under `~/.terraform.d/plugins/` - and add a configuration file called `terraform-provider-openapi.yaml`.
In that file, define a new service called 'antsle' and include the URL to your server like so:
```
version: 1
services:
    antsle:
      swagger-url: https://<myantsle>.antsle.us/swagger.json
```
If you should not use SSL (only recommended for private local networks), add the following directly under your swagger-url: `insecure_skip_verify: true`.

After that, Antsle will be available as a provider in your Terraform-setup.

##Using Antsle as a provider
In your Terraform configuration files, specify the Antsle provider like so
``` 
provider "antsle" {
  apikey_auth = "Token eyJh..."
}
``` 
Notice that you'll need to provide a value for `apikey_auth`. This key will be used to authenticate all requests. To obtain your token, use the `/api/login` endpoint. Add the prefix `Token ` to the returned value so your `apikey_auth` field looks like in the example above. Run `terraform init` to make the new provider available.

###Managing resources
The provider exposes several resources to Terraform. Let's take a look at managing antlets. To create an antlet, simply make use of the resource `antsle_antlets` and specify the desired values like so:
```
resource "antsle_antlets" "antlet1" {
  dname = "antlet1"
  template = "Fedora.lxc"
  ram = 1024
  cpu = 1
  antlet_num = 33
  zpool_name = "antlets"
  compression = "lz4"
}
``` 
When running `terraform plan`, Terraform will check if the antlet exists and perform the appropriate action:

<div class="shdw">
   <img src="terraform.png" height="10em" alt="Using Antsle with terraform">
</div>

#Manage Multiple Nodes

If you have multiple servers you'd like to manage with Terraform, you can register one provider for each server. Let's assume you have two servers running edgeLinux, server1 and server2.
Download and install the provider like described in the single-node application. Once in your `~/.terraform.d/plugins/` directory, duplicate the provider. Make sure to follow this naming scheme: `terraform-provider-<servername>`. In our example, this would be terraform-provider-server1 and terraform-provider-server2.

Next, adjust your configuration accordingly. Like in a single-node application, create a file called `terraform-provider-openapi.yaml` - also in your plugins directory. Add an entry for each server and make sure the name of each service matches the `<servername>` of the corresponding plugin. Again, in our example the configuration would look like this:
```
version: 1
services:
  server1:
    swagger-url: https://server1.antsle.us/swagger.json
  server2:
    swagger-url: https://server2.antsle.us/swagger.json
```

After running `terraform init`, you can make use of each provider and their resources like described in the single-node example above. Only adjust the naming scheme to correspond to your configuration:
```
provider "server1" {
...
}

resource "server1_antlets" "antlet1" {
...
}
```


