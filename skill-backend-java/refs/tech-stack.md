# Java/Spring Boot 기술 스택 상세 참조

## 핵심 프레임워크
- **Java 17 LTS / Java 21 LTS**: Records, Sealed Classes, Pattern Matching, Virtual Threads (21)
- **Spring Boot 3.x**: 최신 LTS 기준
- **Spring Framework 6.x**: Jakarta EE 9+ 기반

## Spring 생태계
- **Spring Security 6**: JWT, OAuth2, Method Security
- **Spring Data JPA**: Repository 패턴, Specification
- **Spring Data Redis**: 캐싱, 세션 관리
- **Spring Batch**: 대용량 배치 처리
- **Spring WebFlux**: 리액티브 프로그래밍 (필요 시)
- **Spring Cloud**: MSA 구성 (Eureka, Gateway, Config)

## ORM & DB
- **Hibernate 6**: JPA 구현체, @NaturalId, @BatchSize
- **QueryDSL 5+**: 타입 안전 동적 쿼리
- **Flyway / Liquibase**: DB 마이그레이션
- **PostgreSQL**: 주 DB (JSONB, 파티셔닝, Full-text search)
- **MySQL 8+**: 대안 DB
- **Redis**: 캐싱, 분산락, Pub/Sub

## 빌드 도구
- **Gradle 8+**: Kotlin DSL 선호
- **Maven**: 레거시 프로젝트

## 테스트
- **JUnit 5 (Jupiter)**: 단위/통합 테스트
- **Mockito 5**: Mock 객체
- **Testcontainers**: 통합 테스트용 실제 DB
- **AssertJ**: 가독성 높은 단언문
- **Spring Boot Test / @WebMvcTest / @DataJpaTest**: 슬라이스 테스트

## API 문서화
- **SpringDoc OpenAPI 3 (Swagger UI)**: REST API 문서
- **Spring REST Docs**: 테스트 기반 문서화

## 메시징
- **Apache Kafka**: 이벤트 스트리밍
- **RabbitMQ**: 메시지 큐

## 아키텍처 패턴
- **레이어드 아키텍처**: Controller → Service → Repository
- **헥사고날 아키텍처**: Port/Adapter 패턴 (복잡한 도메인)
- **CQRS**: 읽기/쓰기 분리 (대규모 시스템)
- **도메인 이벤트**: Spring ApplicationEvent, Kafka

## 성능 최적화
- N+1 방지: `JOIN FETCH`, `@EntityGraph`, `@BatchSize`
- 인덱스 전략: 복합 인덱스, 부분 인덱스
- 캐싱: `@Cacheable`, Redis L2 캐시
- 커넥션 풀: HikariCP 튜닝

## 보안
- OWASP Top 10 대응
- SQL Injection: PreparedStatement, QueryDSL
- XSS: 입력 검증, 출력 이스케이핑
- CSRF: Spring Security CSRF 토큰
- 민감 정보: 환경변수, Vault 관리

## 컨테이너 & 배포
- **Docker / Docker Compose**: 컨테이너화
- **Kubernetes**: 오케스트레이션 (대규모)
- **GitHub Actions / GitLab CI**: CI/CD (설정 파일 작성만, 실행 금지)
