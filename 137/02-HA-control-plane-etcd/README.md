# HA con ETCD incrustado

K3s es capáz de levantar su propio proceso de ETCD y utilizarlo como su
almacenaje de datos, a esto le llaman "ETCD incrustado" (embeded ETCD). Para
tener una configuración de alta disponibilidad con el ETCD incrustado se
necesita provisionar al menos 3 control planes, donde cada cual levanta un ETCD.

Cabe resaltar que la limitante de tener número impares de control planes está
directamente atada a como RAFT el protocolo de consenso es utilizado en ETCD.

Para levantar un cluster HA con ETCD incrustado con el `Vagrantfile` en este
directorio tenemos que hacer lo siguiente:

1. Iniciamos el control plane "leader", acá es identificado como control-plane-0

```sh
$ vagrant up control-plane-0
[ ... Output ... ]
```

2. Tomamos el secure join token del output anterior o bien con:

```sh
vagrant ssh control-plane-0 -c 'sudo cat /var/lib/rancher/k3s/server/node-token'
```

3. Reemplazamos el valor del token en la variable `SERVER_TOKEN` que está en las primeras líneas del Vagrantfile

4. Provisionamos los demás nodos de tipo control plane (y así completar el ETCD quorum)

```sh
$ vagrant up control-plane-1 control-plane-2
[ ... Output ... ]
```

4. Provisionamos el worker node

```sh
$ vagrant up worker
[ ... Output ... ]
```

5. Ahora ya podemos hacer operaciones con `kubectl` dentro de la vm del control-plane-0

```sh
$ kubectl get nodes
NAME              STATUS     ROLES                       AGE     VERSION
control-plane-0   Ready      control-plane,etcd,master   22m     v1.26.3+k3s1
control-plane-1   Ready      control-plane,etcd,master   18m     v1.26.3+k3s1
control-plane-2   Ready      control-plane,etcd,master   14m     v1.26.3+k3s1
worker            Ready      <none>                      6m10s   v1.26.3+k3s1
```

## Utilizar kubectl fuera de la máquina virtual

Esta vez para utilizar `kubectl` fuera de cualquier nodo del control plane no
solo necesitariamos asignar "IP públicas" nuestros nodos de control, sino que
tambien hacer una de las siguientes opciones

- Provisionar un LoadBalancer L4 frente a los control-plane
- Agregar todos los control-plane detrás de un DNS record
- Ó dirigir la carga arbitrariamente a un solo nodo (haciendo de menos el HA)

