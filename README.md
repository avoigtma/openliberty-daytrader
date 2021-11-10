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

