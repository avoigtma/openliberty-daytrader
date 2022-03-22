# openliberty-daytrader

Compiled application from <https://github.com/OpenLiberty/sample.daytrader8> and Dockerfile for container image.

`openshift` folder covers OpenShift deployment resources.

```yaml
oc apply -R -f openshift
```

You will need to adjust the image reference in `deployment.yaml` to the target namespace before deploying.

# Java Options

The `jvm.options` file is used to set the JVM options on OpenLiberty.

See OpenLiberty documentation [https://openliberty.io/docs/21.0.0.10/reference/config/server-configuration-overview.html](https://openliberty.io/docs/21.0.0.10/reference/config/server-configuration-overview.html) 

The example file adds settings (note: insecure - no TLS, no authentication) to JMX. Using these settings, one can to a `oc port-forward pod/openliberty-daytrader-git-xyz 51001:51001 51002:51002` to the Open Liberty pod and connect `jconsole` to remote connection `localhost:51001`.

# Certificates

Samples on different OpenShift Route types and simple TLS certificate configuration in Liberty.

See 'certs' subdirectory.

## Create custom keystone

Create custom keystore. Using Java keytool - create a PKCS#12 key store:

```shell
keytool -genkeypair -keystore mykeystore.p12 -alias master \
-storetype pkcs12 -keyalg RSA -keysize 2048 -validity 3650 \
-storepass mykeystorepass1234 \
-dname "CN=localhost,O=home,C=DE" \
-ext 'san=dns:localhost,dns:web.internal,email:me@mail.internal'
```

To export the self-signed certificate, we'll use that later on for a reencrypt-Route in OpenShift:
```shell
keytool -exportcert -keystore mykeystore.p12 -file mycert.crt \
-alias master -rfc -storepass mykeystorepass1234
```

Review the resulting certificate::
```shell
keytool -printcert -file mycert.crt
```

## Liberty Configuration

Put keystore into a secret, as well as the modified `server.xml`:

```yaml
oc create secret generic server-cert --from-file=./mykeystore.p12 
oc create secret generic server-config --from-file=server.xml=./server-ssl.xml
```


Additional changes:

* add TLS port `9443` to the service
* Use modified deployment which mounts the customised `server.xml` and the keystone from a secret.

```shell
oc apply -f certs/service.yaml
oc apply -f certs/deployment.yaml
```

## Routes

### Edge route

```shell
oc apply -f route-edge.yaml
```

### Passthru route

> Note the route presents the self-signed certificate added to Liberty! You will need to accept this certificate in the Web browser (and Chrome may not want to do this).

```shell
oc apply -f route-edge.yaml
```

### Reencrypt Route

> This example 'reencrypt' route Yaml file has a dummy destination CA set, only. Hence it does not work (yet) and OpenShift shows it as 'rejected'!

Hence, replace the 'dummy' certificate placeholder in the `route-reenc.yaml` file with the contents of our generated TLS server certificate (file: `mycert.crt`).

Then apply the file

```shell
oc apply -f route-reenc.yaml
```
