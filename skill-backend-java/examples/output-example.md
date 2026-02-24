# 백엔드 개발 산출물 예시 (Java/Spring Boot)

## 기본 정보
| 항목 | 내용 |
|------|------|
| 작업일 | 2026-02-20 |
| 담당 | 시니어 백엔드 개발자 (Java/Spring Boot) |
| 작업 유형 | 성능개선 |
| 작업명 | 주문 목록 조회 API N+1 쿼리 해결 |

## 작업 요약
주문 목록 조회 시 발생하던 N+1 쿼리 문제를 해결하여 API 응답시간을 83% 개선했습니다. `JOIN FETCH`와 `@BatchSize` 조합을 적용하고, 자주 조회되는 데이터는 Redis 캐싱을 추가했습니다.

## 변경 파일 목록
| 파일 경로 | 변경 유형 | 변경 내용 |
|-----------|-----------|-----------|
| `src/main/java/com/app/order/repository/OrderRepository.java` | 수정 | JPQL JOIN FETCH 쿼리 추가 |
| `src/main/java/com/app/order/service/OrderService.java` | 수정 | 캐싱 적용, 쿼리 메서드 변경 |
| `src/main/java/com/app/order/entity/Order.java` | 수정 | @BatchSize 어노테이션 추가 |
| `src/main/java/com/app/order/entity/OrderItem.java` | 수정 | fetch = FetchType.LAZY 명시 |
| `src/main/resources/application.yml` | 수정 | Redis 캐시 TTL 설정 추가 |

## 변경 내역
### N+1 쿼리 해결 (OrderRepository.java)
- **변경 전**: `findAll()` 사용 → Order 10개 조회 시 OrderItem 10번 추가 조회 (N+1)
- **변경 후**: `JOIN FETCH` JPQL 쿼리로 단일 쿼리 조회
- **변경 이유**: DB 쿼리 수 폭발적 증가로 인한 응답시간 지연

### Redis 캐싱 적용 (OrderService.java)
- **변경 전**: 매 요청마다 DB 조회
- **변경 후**: `@Cacheable("orders")` 적용, TTL 5분
- **변경 이유**: 동일 데이터 반복 조회 최소화

## 성능 개선율
| 지표 | 변경 전 | 변경 후 | 개선율 |
|------|---------|---------|--------|
| API 응답시간 | 1,240ms | 210ms | 83% ↑ |
| DB 쿼리 수 (주문 10건) | 11쿼리 | 1쿼리 | 91% ↓ |
| 처리량 (TPS) | 45 | 280 | 522% ↑ |
| 캐시 히트율 | 0% | 78% | - |

## 주요 구현 내용
```java
// OrderRepository.java - JOIN FETCH 적용
@Query("SELECT DISTINCT o FROM Order o " +
       "JOIN FETCH o.orderItems oi " +
       "JOIN FETCH oi.product p " +
       "WHERE o.member.id = :memberId " +
       "ORDER BY o.createdAt DESC")
List<Order> findOrdersWithItemsByMemberId(@Param("memberId") Long memberId);

// OrderService.java - 캐싱 적용
@Cacheable(value = "orders", key = "#memberId + '_' + #pageable.pageNumber")
@Transactional(readOnly = true)
public Page<OrderResponse> getOrders(Long memberId, Pageable pageable) {
    return orderRepository.findOrdersWithItemsByMemberId(memberId, pageable)
            .map(OrderResponse::from);
}
```

## API 변경 사항
| 메서드 | 엔드포인트 | 변경 내용 |
|--------|-----------|-----------|
| GET | /api/v1/orders | 응답 구조 동일, 성능만 개선 |

## 영향 범위
- **영향 도메인/서비스**: OrderService, OrderRepository
- **DB 스키마 변경**: 없음
- **하위 호환성**: 유지
- **마이그레이션 필요**: 없음

## 테스트 확인
- [x] 단위 테스트 통과 (JUnit 5)
- [x] 통합 테스트 통과 (Testcontainers)
- [x] API 동작 확인 (Swagger UI)
- [x] 트랜잭션/롤백 동작 확인

## 후속 작업 및 알려진 이슈
- 캐시 무효화 전략 추가 필요 (주문 상태 변경 시 캐시 eviction 구현 예정)
- 대용량 주문 데이터(10만건+) 환경에서 페이지네이션 추가 최적화 검토 필요
