# Luxury Stay - Hệ thống Quản lý Khách sạn

## Cấu trúc

### Frontend (HTML, CSS, JS)
| Trang | Chức năng |
|-------|-----------|
| index.html | Trang chủ + Tìm kiếm phòng |
| login.html | Đăng nhập / Đăng ký (Khách hoặc Nhân viên) |
| rooms.html | Xem danh sách phòng (cần đăng nhập) |
| room-detail.html | Chi tiết phòng + Thêm vào giỏ |
| cart.html | Giỏ đặt phòng (xem, xóa) |
| checkout.html | Đặt hàng + Thanh toán (tiền mặt, NH, MoMo, VNPay) |
| orders.html | Xem đơn / Hủy đơn chờ xác nhận |

### Backend (PHP + MySQL)
| File | Chức năng |
|------|-----------|
| sql/database.sql | Schema + dữ liệu mẫu |
| api/config.php | Kết nối DB + session |
| api/auth.php | Login / Register / Logout API |
| admin/dashboard.html | Thống kê |
| admin/bookings.html | QL đơn hàng (cập nhật trạng thái, thanh toán) |
| admin/rooms.html | QL phòng (sản phẩm) |
| admin/users.html | QL tài khoản (user / staff) |
| admin/categories.html | QL danh mục phòng |

## Tài khoản demo
- **Admin:** admin@luxurystay.vn / password
- **Nhân viên:** staff@luxurystay.vn / password  
- **Khách hàng:** user@email.com / password

## Cách chạy
1. Import `sql/database.sql` vào MySQL
2. Cấu hình `api/config.php` (host, user, pass)
3. Đặt project vào thư mục web server (XAMPP/Laragon)
4. Mở `index.html` hoặc `login.html`

**Lưu ý:** Frontend hiện dùng localStorage để demo đầy đủ. Kết nối PHP API khi deploy thật.
