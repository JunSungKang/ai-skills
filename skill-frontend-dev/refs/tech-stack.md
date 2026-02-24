# 프론트엔드 기술 스택 상세 참조

## 핵심 프레임워크
- **Next.js 14+**: App Router, Server Components, Server Actions, Streaming, Parallel Routes
- **React 18+**: Concurrent Features, Suspense, useTransition, useDeferredValue
- **TypeScript 5+**: strict 모드, 제네릭, 유틸리티 타입, 타입 가드

## 스타일링
- **Tailwind CSS 3+**: JIT 모드, 커스텀 테마, 반응형(mobile-first)
- **CSS Modules**: 컴포넌트 격리 스타일
- **shadcn/ui**: Radix UI 기반 접근 가능한 컴포넌트
- **Framer Motion**: 애니메이션 (필요 시)

## 상태 관리 & 데이터 패칭
- **TanStack Query v5**: 서버 상태, 캐싱, 무한 스크롤, 낙관적 업데이트
- **Zustand**: 클라이언트 전역 상태 (Redux 대체)
- **React Hook Form + Zod**: 폼 관리 및 유효성 검사

## 테스트
- **Vitest**: 단위/통합 테스트 (Jest 호환)
- **React Testing Library**: 컴포넌트 테스트
- **Playwright**: E2E 테스트
- **MSW (Mock Service Worker)**: API 모킹

## 빌드 & 도구
- **Turbopack**: Next.js 내장 번들러
- **ESLint**: next/core-web-vitals, @typescript-eslint
- **Prettier**: 코드 포매팅
- **Husky + lint-staged**: 커밋 훅

## 성능 최적화 기준
- **Core Web Vitals**: LCP < 2.5s, INP < 200ms, CLS < 0.1
- **이미지 최적화**: next/image, WebP/AVIF 포맷
- **코드 스플리팅**: dynamic import, React.lazy
- **번들 분석**: @next/bundle-analyzer

## 접근성 (a11y)
- WCAG 2.1 AA 준수
- 시맨틱 HTML 사용
- ARIA 속성 적절히 사용
- 키보드 네비게이션 지원
- 색상 대비비 4.5:1 이상

## API 통신
- **Axios / Fetch API**: HTTP 클라이언트
- **tRPC**: 타입 안전한 API (필요 시)
- **GraphQL + Apollo Client**: (필요 시)

## 모노레포 (대규모 프로젝트)
- **Turborepo**: 모노레포 빌드 시스템
- **pnpm workspaces**: 패키지 관리

## 배포 환경
- **Vercel**: Next.js 최적화 배포
- **Docker**: 컨테이너화
- **GitHub Actions / GitLab CI**: CI/CD (설정 파일 작성만, 실행 금지)
