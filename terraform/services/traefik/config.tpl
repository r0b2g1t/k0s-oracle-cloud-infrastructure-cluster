|
  deployment:
    replicas: 2
  logs:
    general:
      level: ERROR
    access:
      enabled: true
  additionalArguments: 
    - "--providers.kubernetesingress.ingressclass=traefik-internal"
    - "--ping"
    - "--ping.entrypoint=web"
    - "--serversTransport.insecureSkipVerify=true"

  resources:
    requests:
      cpu: "100m"
      memory: "50Mi"
    limits:
      cpu: "300m"
      memory: "150Mi"

  ports:
    traefik:
      port: 9000
      expose: false
      exposedPort: 9000
      protocol: TCP
      healthchecksPort: 8000
    web:
      port: 8000
      expose: true
      exposedPort: 80
      nodePort: 30080
      protocol: TCP
    websecure:
      port: 8443
      expose: true
      exposedPort: 443
      nodePort: 30443
      protocol: TCP
      tls:
        enabled: true
  service:
    enabled: true
    type: LoadBalancer
    spec:
      externalTrafficPolicy: Local
      loadBalancerIP: ${load_balancer_ip}