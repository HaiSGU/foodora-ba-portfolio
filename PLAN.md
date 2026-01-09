# PLAN — Foodora BA Portfolio (Kế hoạch Deliverables)

## A. THÔNG TIN CƠ BẢN

- **Tên dự án:** FOODORA — Ứng dụng đặt & lấy đồ ăn tại chỗ (Pickup)
- **Trọng tâm:** Nghiệp vụ • Trải nghiệm người dùng • Quy trình
- **Bài toán:** Nhà hàng XYZ mất ~30% lợi nhuận cho các platform giao đồ ăn, không có dữ liệu khách hàng trực tiếp, quy trình nhận đơn thủ công gây nhầm lẫn.
- **Giải pháp:** Xây dựng **mobile app** cho khách đặt hàng + **web app/dashboard** quản lý nội bộ cho nhà hàng.
- **Vai trò của tôi:** Business Analyst (dẫn dắt từ khám phá nhu cầu đến UAT).

---

## B. DANH MỤC DELIVERABLE CHI TIẾT

> Ghi chú: Cột “Công cụ” là công cụ thực hiện; cột “Điểm nhấn” là tiêu chí/điểm cần thể hiện để tạo giá trị BA khi đi xin intern.

### 1. GIAI ĐOẠN KHÁM PHÁ & PHÂN TÍCH

| Deliverable | Công cụ | Mô tả | Điểm nhấn |
|---|---|---|---|
| **1.1 Business Case (1 trang)** | Google Docs/Word | Tóm tắt: Vấn đề, giải pháp, lợi ích (mục tiêu tăng ~25% lợi nhuận), rủi ro, ước tính tác động. | Viết theo góc nhìn tư vấn cho chủ nhà hàng (problem → impact → proposal → KPI). |
| **1.2 Stakeholder Analysis Matrix** | Draw.io | Phân loại: High/High (Chủ quán), High/Low (Bếp), Low/High (Khách hàng), … | Kèm chiến lược giao tiếp theo nhóm (tần suất, kênh, nội dung). |
| **1.3 User Personas (2 personas)** | Figma/Google Slides | 2 persona tiêu biểu: **An (Khách hàng)** và **Bình (Thu ngân/nhân viên quán)**. | Có ảnh, quote, mục tiêu, hành vi, pain points, nhu cầu. |
| **1.4 Customer Journey Map (CJM)** | Miro/Draw.io | Hành trình: “Đói” → “Tìm quán” → “Xem menu” → “Đặt” → “Chờ” → “Nhận” → “Dùng”. | Chỉ ra điểm chạm, cảm xúc, vấn đề và cơ hội cải tiến. |

**Tham chiếu tài liệu hiện có:**
- assets/docs/FOODORA – Customer Journey Map (Customer Ordering & Pickup).pdf
- assets/docs/Business Case.docx
- assets/images/diagrams/*.drawio

---

### 2. GIAI ĐOẠN ĐỊNH NGHĨA YÊU CẦU

| Deliverable | Công cụ | Mô tả | Điểm nhấn |
|---|---|---|---|
| **2.1 Product Requirements Document (PRD)** | Google Docs/Word | Tài liệu tổng hợp: (1) Tổng quan (từ Business Case), (2) User Stories & Acceptance Criteria, (3) Wireframes & Flow, (4) Rules & Constraints. | Đây là tài liệu **chính** (thường 8–12 trang), liên kết đến các deliverables khác. |
| **2.2 Jira Backlog (Epic/User Story)** | Jira | Tạo project “FOODORA”; cấu trúc Epic gợi ý: **Quản lý Menu**, **Quy trình đặt hàng**, **Thanh toán & xác nhận**, **Giao diện quản trị**. | Mỗi User Story tuân chuẩn INVEST; dùng MoSCoW để gán priority/label. |
| **2.3 Use Case Diagram** | Draw.io | Hiển thị 2 actors chính (Khách hàng, Thu ngân) và 5–7 use case cốt lõi. | Đơn giản, rõ ràng, dùng để align scope. |
| **2.4 Business Process Model (BPMN 2.0)** | Draw.io | 2 quy trình song song: (1) Quy trình khách hàng đặt hàng, (2) Quy trình nội bộ xử lý đơn. | Dùng đúng ký hiệu Pool/Lane/Gateway; thể hiện rõ điểm giao giữa 2 quy trình. |

#### 2.4 — Hướng dẫn vẽ BPMN 2.0 (portfolio-ready)

**Mục tiêu:** Vẽ **2 quy trình chạy song song** và thể hiện rõ các điểm “handoff” (giao tiếp/đồng bộ trạng thái) giữa khách hàng và nội bộ.

**Bố cục khuyến nghị (Pool/Lane):**
- **Pool 1: Customer** (có thể chia Lane: *Customer* và *Customer App/System* nếu muốn thể hiện hệ thống)
- **Pool 2: Restaurant Operations** (Lane: *Cashier/Front desk* và *Kitchen*)

**Ký hiệu bắt buộc nên có:**
- Start/End event
- Task/User task
- Gateway (XOR) cho quyết định (ví dụ: món hết hàng? xác nhận đơn? huỷ?)
- Message flow giữa 2 pool tại các điểm handoff
- Intermediate event (tối thiểu 1): timer/message (ví dụ: quá thời gian xác nhận)

**Quy trình 1 — Khách hàng đặt hàng (Customer Pool):**
1. **Start:** Khách mở app
2. Xem menu → chọn món → chỉnh số lượng/tuỳ chọn
3. Xem giỏ hàng → nhập ghi chú (tuỳ chọn) → xác nhận đơn
4. **Gateway (XOR):** Thông tin đơn hợp lệ?
	- No → báo lỗi/điều chỉnh → quay lại giỏ hàng
	- Yes → gửi yêu cầu đặt đơn (message) sang nhà hàng
5. Nhận phản hồi xác nhận/từ chối (message)
6. **Gateway (XOR):** Đơn được xác nhận?
	- No → hiển thị lý do từ chối (món hết/ngoài giờ) → End
	- Yes → theo dõi trạng thái: *Confirmed → Preparing → Ready*
7. Khi trạng thái “Ready”: khách đến quầy nhận
8. Thanh toán tại quầy (Phase 1: pay-at-counter) → nhận hàng
9. **End:** Đơn hoàn tất

**Quy trình 2 — Nội bộ xử lý đơn (Restaurant Operations Pool):**
1. **Start:** Nhận yêu cầu đặt đơn từ app (message start hoặc receive task)
2. Cashier kiểm tra quán đang mở? item còn hàng?
3. **Gateway (XOR):** Có thể nhận đơn?
	- No → gửi “Reject order + reason” (message) → End
	- Yes → xác nhận đơn (set status = Confirmed) và gửi “Order confirmed” (message)
4. Chuyển đơn cho bếp (task/hand-off nội bộ)
5. Kitchen chuẩn bị món (set status = Preparing)
6. **Gateway (XOR):** Có issue trong quá trình làm? (hết món/phát sinh)
	- Yes → thông báo Cashier xử lý (điều chỉnh/huỷ) → gửi cập nhật sang khách (message)
	- No → tiếp tục
7. Kitchen báo món xong (set status = Ready)
8. Cashier cập nhật “Ready for pickup” gửi sang khách (message)
9. Khách đến nhận → Cashier thu tiền (Phase 1) → giao hàng (set status = Completed)
10. **End:** Đơn hoàn tất

**Điểm giao giữa 2 quy trình (handoff points cần thể hiện bằng message flow):**
- H1: Customer “Place order” → Restaurant “Receive order request”
- H2: Restaurant “Confirm/Reject” → Customer “See confirmation/rejection + reason”
- H3: Restaurant “Status updates: Preparing/Ready” → Customer “Track status”
- H4: Customer “Arrive for pickup” (implicit) → Restaurant “Handover + payment” (có thể thể hiện bằng message hoặc task đồng bộ)

**Ngoại lệ tối thiểu nên thể hiện (chọn 1–2 để diagram gọn):**
- Quá thời gian xác nhận (timer): nếu sau X phút chưa confirm → auto-cancel + notify
- Khách huỷ trước khi “Preparing” (XOR): cho phép/không cho phép theo rule
- Item hết hàng sau khi đã confirm (exception): cashier đề xuất thay thế/hoàn tiền tại quầy

**Output cần nộp trên portfolio:**
- File draw.io trong `assets/images/diagrams/` (tên gợi ý: `BPMN - Customer Order & Internal Processing.drawio`)
- Xuất PNG/SVG để nhúng vào website (tối thiểu 1 ảnh rõ chữ)

**Tham chiếu tài liệu hiện có:**
- assets/docs/PRD.docx
- assets/docs/Jira Backlog and Technical Stories.docx
- assets/docs/Use Case Description.docx

---

### 3. GIAI ĐOẠN THIẾT KẾ GIẢI PHÁP

| Deliverable | Công cụ | Mô tả | Điểm nhấn |
|---|---|---|---|
| **3.1 Figma Prototype (Interactive)** | Figma | 2 prototype: (1) **Mobile App (khách):** 8–10 màn hình chính, (2) **Web Dashboard (thu ngân):** 4–5 màn hình. | Có thể click qua lại giữa màn hình; dùng Auto Layout/Components để thể hiện tính hệ thống. |
| **3.2 Wireflow / Screen Flow Diagram** | Figma/Draw.io | Dùng thumbnail từ Figma, nối thành luồng người dùng hoàn chỉnh (happy path). | Giúp dev/QA hiểu navigation; mapping với User Stories. |
| **3.3 Entity Relationship Diagram (ERD)** | Draw.io | Các entity chính: User, Restaurant, Menu, Order, OrderItem, Payment, … | Quan hệ 1-n, thuộc tính cơ bản (id, name, status, timestamp). |

**Tham chiếu tài liệu hiện có:**
- assets/docs/System Architecture Overview.docx
- assets/images/diagrams/*.drawio

---

### 4. GIAI ĐOẠN KIỂM THỬ & CHUYỂN GIAO

| Deliverable | Công cụ | Mô tả | Điểm nhấn |
|---|---|---|---|
| **4.1 UAT Test Plan & Cases** | Google Sheets/Excel | Bảng test gồm: 10–15 test case cho 2–3 scenario chính; cột: ID, Mô tả, Steps, Expected, Actual, Tester. | Cover Happy Path + 1–2 lỗi thường gặp; liên kết requirement/story. |
| **4.2 UAT Sign-off Form** | Google Docs/Word | Mẫu đơn giản có chữ ký điện tử (dùng signature generator). | Ví dụ nội dung: “Tôi phê duyệt triển khai phiên bản 1.0”. |
| **4.3 Traceability Matrix (đơn giản)** | Google Sheets/Excel | Ma trận liên kết: User Story → Test Case → UAT Result. | Chứng minh khả năng theo dõi yêu cầu end-to-end. |

---

## C. LƯU Ý THỰC THI (để phù hợp hồ sơ Intern BA)

- Giữ scope vừa phải (MVP), ưu tiên luồng đặt món pickup end-to-end.
- Mỗi deliverable đều nên có liên kết chéo về PRD/Jira để thể hiện traceability.
- Nếu cần trình bày trên website portfolio: link từ trang Deliverables tới file trong `assets/docs/`.
