# openliberty-daytrader

Compiled application from <https://github.com/OpenLiberty/sample.daytrader8> and Dockerfile for container image.

`openshift` folder covers OpenShift deployment resources.

```yaml
oc apply -R -f openshift
```

You will need to adjust the image reference in `deployment.yaml` to the target namespace before deploying.

