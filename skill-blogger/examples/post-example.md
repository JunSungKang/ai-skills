# 포스팅 예시 - Kubernetes 헬스체크 완전 가이드

<!-- 저장 경로 예시: C:\Users\user\docs\kubernetes-healthcheck-guide\kubernetes-healthcheck-guide.md -->

---

> **요약**
> 쿠버네티스(Kubernetes)에서 파드(Pod)의 안정적인 운영을 위한 헬스체크 메커니즘을 알아봅니다.
> Liveness Probe, Readiness Probe, Startup Probe 세 가지 방식의 차이점과 적절한 설정 방법을 다루며,
> 실제 Spring Boot 애플리케이션에 적용하는 예제도 함께 제공합니다.
> 이 글을 읽고 나면 서비스 중단 없이 안정적인 롤링 업데이트를 구성할 수 있습니다.

---

# Kubernetes 헬스체크 완전 가이드: Probe 3종 세트 마스터하기

**작성일**: 2026-02-24
**태그**: `Kubernetes` `DevOps` `클라우드` `Spring Boot`
**난이도**: 중급

---

## 들어가며

"배포했는데 왜 서비스가 안 되지?" 쿠버네티스를 처음 쓰는 분들이 가장 많이 겪는 상황입니다.
파드가 `Running` 상태인데 실제로는 요청을 처리하지 못하는 경우, 또는 애플리케이션이 죽었는데도
쿠버네티스가 모르고 트래픽을 계속 보내는 경우가 빈번합니다.

이 문제를 해결하는 핵심이 바로 **Probe(헬스체크)** 입니다. 쿠버네티스는 세 가지 Probe를 통해
컨테이너의 상태를 주기적으로 확인하고, 문제가 있는 파드는 자동으로 재시작하거나 트래픽에서
제외합니다. 지금부터 각 Probe의 역할과 올바른 설정 방법을 살펴보겠습니다.

---

## Probe의 세 가지 종류

### 1. Liveness Probe: "살아있나요?"

Liveness Probe는 컨테이너가 정상적으로 동작 중인지 확인합니다. 실패하면 쿠버네티스가
컨테이너를 **재시작**합니다. 데드락이나 무한루프 등으로 응답이 없는 상황에 유용합니다.

```yaml
livenessProbe:
  httpGet:
    path: /actuator/health/liveness
    port: 8080
  initialDelaySeconds: 30    # 최초 체크 전 대기 시간
  periodSeconds: 10          # 체크 주기
  failureThreshold: 3        # 실패 허용 횟수
```

### 2. Readiness Probe: "요청 받을 준비됐나요?"

Readiness Probe는 컨테이너가 트래픽을 받을 준비가 됐는지 확인합니다. 실패하면 해당 파드를
서비스 엔드포인트에서 **일시 제외**합니다 (재시작하지 않음). DB 연결 완료, 캐시 워밍업 등의
초기화 과정에서 특히 중요합니다.

```yaml
readinessProbe:
  httpGet:
    path: /actuator/health/readiness
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 3
```

### 3. Startup Probe: "시작 완료됐나요?"

Startup Probe는 느린 시작을 가진 애플리케이션을 위한 Probe입니다. 이 Probe가 성공하기 전까지는
Liveness/Readiness Probe가 동작하지 않습니다. 레거시 시스템이나 초기화가 오래 걸리는 서비스에
활용합니다.

```yaml
startupProbe:
  httpGet:
    path: /actuator/health
    port: 8080
  failureThreshold: 30       # 최대 30번 × 10초 = 300초 대기 허용
  periodSeconds: 10
```

---

## Spring Boot Actuator 연동

Spring Boot 2.3+ 이상에서는 Actuator를 통해 Kubernetes Probe에 최적화된 엔드포인트를
기본 제공합니다.

### 의존성 추가

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### application.yml 설정

```yaml
management:
  health:
    livenessstate:
      enabled: true
    readinessstate:
      enabled: true
  endpoint:
    health:
      probes:
        enabled: true
  endpoints:
    web:
      exposure:
        include: health
```

위 설정만으로 `/actuator/health/liveness`와 `/actuator/health/readiness` 엔드포인트가
자동으로 활성화됩니다.

---

## Probe 방식 비교

| 방식 | 설명 | 권장 사용 케이스 |
|------|------|----------------|
| `httpGet` | HTTP GET 요청 응답 코드 확인 (2xx, 3xx) | REST API 서버 |
| `tcpSocket` | TCP 포트 연결 가능 여부 확인 | DB, MQ 등 TCP 서비스 |
| `exec` | 컨테이너 내부 명령어 실행 결과 확인 | 파일 존재 여부 등 |
| `grpc` | gRPC Health Check 프로토콜 (v1.24+) | gRPC 서비스 |

---

## 실전 전체 설정 예시

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: app
          image: my-app:latest
          ports:
            - containerPort: 8080
          startupProbe:
            httpGet:
              path: /actuator/health
              port: 8080
            failureThreshold: 30
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /actuator/health/liveness
              port: 8080
            initialDelaySeconds: 0
            periodSeconds: 10
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: 8080
            initialDelaySeconds: 0
            periodSeconds: 5
            failureThreshold: 3
```

> 💡 **핵심 포인트**
> Startup Probe를 사용하면 `initialDelaySeconds`를 0으로 설정해도 됩니다.
> 서비스가 완전히 시작된 후에만 Liveness/Readiness Probe가 동작하기 때문입니다.

---

## 마무리

쿠버네티스 Probe는 단순한 설정처럼 보이지만, 잘못 구성하면 불필요한 재시작이나 서비스 중단의
원인이 됩니다. 세 가지 Probe의 역할을 명확히 이해하고 애플리케이션 특성에 맞게 적용하는 것이
중요합니다.

**이 글의 핵심 요약:**
- **Liveness Probe**: 죽은 컨테이너를 재시작 (데드락, 무응답 방지)
- **Readiness Probe**: 준비 안 된 파드에 트래픽 차단 (안전한 롤링 업데이트)
- **Startup Probe**: 느린 시작 애플리케이션 보호 (Liveness/Readiness 동작 전 방어막)
- Spring Boot Actuator로 Probe 엔드포인트를 쉽게 노출 가능

---

## 참고 자료

- [Kubernetes 공식 문서 - Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- [Spring Boot Actuator - Kubernetes Probes](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html#actuator.endpoints.kubernetes-probes)
- [Configure Graceful Shutdown - Spring Boot](https://docs.spring.io/spring-boot/docs/current/reference/html/web.html#web.graceful-shutdown)

---

*이 포스팅이 도움이 되셨나요? 댓글로 의견을 남겨주세요!*
