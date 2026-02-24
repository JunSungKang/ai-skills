# 프레젠테이션 제작 가이드

## 슬라이드 디자인 원칙
- **1슬라이드 1메시지**: 슬라이드당 전달하려는 핵심 포인트는 반드시 1개
- **6×6 규칙**: 불릿 포인트 최대 6개, 각 불릿 최대 6단어
- **시각적 위계**: 제목(40pt+) > 소제목(28pt+) > 본문(20pt+)
- **여백 활용**: 슬라이드 면적의 30% 이상 여백 유지

## 추천 색상 팔레트

### 비즈니스/기업 (모던 블루)
```
주색: #1E3A5F (진한 네이비)
강조: #0080FF (밝은 블루)
배경: #FFFFFF / #F5F7FA
텍스트: #1A1A2E
```

### 기술/개발 (다크 테마)
```
주색: #0D1117 (다크 배경)
강조: #58A6FF (코드 블루)
포인트: #3FB950 (그린)
텍스트: #E6EDF3
```

### 교육/강의 (웜톤)
```
주색: #FF6B35 (오렌지)
강조: #F7C59F (라이트 오렌지)
배경: #FFFEF7
텍스트: #2D2926
```

---

## HTML 프레젠테이션 코드 구조

### 기본 HTML 템플릿
```html
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{발표 제목}</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'Noto Sans KR', 'Malgun Gothic', sans-serif;
         background: #000; overflow: hidden; }

  .slide-container { width: 100vw; height: 100vh; position: relative; }

  .slide {
    display: none;
    width: 100%; height: 100%;
    position: absolute; top: 0; left: 0;
    padding: 60px;
    flex-direction: column;
    justify-content: center;
    background: {배경색};
  }
  .slide.active { display: flex; }

  .slide-title {
    font-size: clamp(28px, 4vw, 52px);
    font-weight: 700;
    color: {제목색};
    margin-bottom: 40px;
    line-height: 1.2;
  }

  .slide-content ul { list-style: none; padding: 0; }
  .slide-content li {
    font-size: clamp(16px, 2.2vw, 28px);
    padding: 12px 0 12px 30px;
    position: relative;
    color: {텍스트색};
  }
  .slide-content li::before {
    content: '▸';
    position: absolute; left: 0;
    color: {강조색};
  }

  /* 진행 바 */
  .progress-bar {
    position: fixed; bottom: 0; left: 0;
    height: 4px; background: {강조색};
    transition: width 0.3s ease;
  }

  /* 슬라이드 번호 */
  .slide-number {
    position: fixed; bottom: 20px; right: 30px;
    font-size: 14px; color: #999;
  }

  /* 프린트 모드 */
  @media print {
    .slide { display: flex !important; page-break-after: always;
             height: 100vh; position: relative; }
    .progress-bar, .slide-number { display: none; }
  }
</style>
</head>
<body>
<div class="slide-container">
  <!-- 슬라이드 1 -->
  <div class="slide active" id="slide-1">
    <h1 class="slide-title">{제목}</h1>
    <div class="slide-content">
      <ul>
        <li>{내용 1}</li>
        <li>{내용 2}</li>
      </ul>
    </div>
  </div>
  <!-- 추가 슬라이드... -->
</div>

<div class="progress-bar" id="progress"></div>
<div class="slide-number" id="slideNum">1 / {총슬라이드수}</div>

<script>
  let current = 0;
  const slides = document.querySelectorAll('.slide');
  const total = slides.length;

  function goTo(n) {
    slides[current].classList.remove('active');
    current = Math.max(0, Math.min(n, total - 1));
    slides[current].classList.add('active');
    document.getElementById('progress').style.width =
      ((current + 1) / total * 100) + '%';
    document.getElementById('slideNum').textContent =
      (current + 1) + ' / ' + total;
  }

  document.addEventListener('keydown', e => {
    if (e.key === 'ArrowRight' || e.key === ' ') goTo(current + 1);
    if (e.key === 'ArrowLeft') goTo(current - 1);
    if (e.key === 'f' || e.key === 'F') document.documentElement.requestFullscreen?.();
  });

  // 터치 스와이프
  let touchX = 0;
  document.addEventListener('touchstart', e => touchX = e.touches[0].clientX);
  document.addEventListener('touchend', e => {
    const diff = touchX - e.changedTouches[0].clientX;
    if (Math.abs(diff) > 50) goTo(current + (diff > 0 ? 1 : -1));
  });

  goTo(0);
</script>
</body>
</html>
```

---

## PPTX 생성 스크립트 구조 (python-pptx)

```python
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN

def create_presentation():
    prs = Presentation()
    prs.slide_width = Inches(13.33)   # 16:9
    prs.slide_height = Inches(7.5)

    # 색상 상수
    COLOR_PRIMARY = RGBColor(0x1E, 0x3A, 0x5F)
    COLOR_ACCENT  = RGBColor(0x00, 0x80, 0xFF)
    COLOR_BG      = RGBColor(0xFF, 0xFF, 0xFF)
    COLOR_TEXT    = RGBColor(0x1A, 0x1A, 0x2E)

    # 레이아웃: 빈 슬라이드 사용
    blank_layout = prs.slide_layouts[6]

    def add_slide(title_text, bullets):
        slide = prs.slides.add_slide(blank_layout)

        # 배경 색상
        bg = slide.background
        fill = bg.fill
        fill.solid()
        fill.fore_color.rgb = COLOR_BG

        # 제목
        title_box = slide.shapes.add_textbox(
            Inches(0.8), Inches(0.5), Inches(11.7), Inches(1.5))
        tf = title_box.text_frame
        tf.word_wrap = True
        p = tf.paragraphs[0]
        p.text = title_text
        p.font.size = Pt(36)
        p.font.bold = True
        p.font.color.rgb = COLOR_PRIMARY

        # 불릿 포인트
        content_box = slide.shapes.add_textbox(
            Inches(0.8), Inches(2.2), Inches(11.7), Inches(4.5))
        tf2 = content_box.text_frame
        tf2.word_wrap = True
        for i, bullet in enumerate(bullets):
            p2 = tf2.paragraphs[0] if i == 0 else tf2.add_paragraph()
            p2.text = f"▸  {bullet}"
            p2.font.size = Pt(22)
            p2.font.color.rgb = COLOR_TEXT
            p2.space_before = Pt(8)

        return slide

    # 슬라이드 추가
    add_slide("슬라이드 제목", ["내용 1", "내용 2", "내용 3"])

    prs.save("{파일명}.pptx")
    print("PPTX 파일 생성 완료: {파일명}.pptx")

if __name__ == "__main__":
    create_presentation()
```

---

## 발표 스크립트 작성 팁
- **오프닝**: 청중의 관심을 끄는 질문이나 통계로 시작
- **전환 멘트**: 각 슬라이드 마지막에 다음 슬라이드로 자연스럽게 연결
- **강조**: 숫자/데이터는 구체적으로 말하기 ("약 50%" 대신 "정확히 55%")
- **클로징**: 핵심 메시지 1~2개를 다시 정리하고 행동 촉구(Call to Action)
- **시간**: 슬라이드당 평균 2~3분 (총 발표 시간 ÷ 슬라이드 수)
