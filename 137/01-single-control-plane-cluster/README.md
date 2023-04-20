# Single control-plane cluster

El "single node cluster" de K3s es super sencillo, pero que tal si queremos
replicar un cluster con al menos un worker node.

Lo podemos hacer de la siguiente manera.

1. Iniciamos el control-plane

```sh
$ vagrant up control-plane
[ ... Output ... ]
```

2. Tomamos el control-plane token del output anterior o bien con:

```sh
vagrant ssh control-plane -c 'sudo cat /var/lib/rancher/k3s/server/node-token'
```

3. Reemplazamos el valor del token en la variable `SERVER_TOKEN` que está en las primeras líneas del Vagrantfile

4. Provisionamos el worker node

```sh
$ vagrant up worker
[ ... Output ... ]
```

5. Ahora ya puedes hacer operaciones con `kubectl` dentro de la vm del control-plane

```sh
$ vagrant ssh control-plane 
$ kubectl get nodes
NAME            STATUS   ROLES                  AGE     VERSION
control-plane   Ready    control-plane,master   5m44s   v1.26.3+k3s1
worker          Ready    <none>                 11s     v1.26.3+k3s1
```

## Acerca de las variables de entorno que usamos

La instalación de vagrant utilizó multiples variables de entorno para modificar
el comportamiento del provisionamiento. Cada una de estas
[están documentadas acá](https://docs.k3s.io/reference/env-variables).

## Utilizar kubectl fuera de la máquina virtual

Por brevedad omití agregar una interfaz pública a la máquina virtual del
`control-plane`, por lo cual solo se puede interactuar con el cluster desde
dentro de la máquina virtual.

Esto será agregado posterior al capítulo #137 de "La hora de Kubernetes".
