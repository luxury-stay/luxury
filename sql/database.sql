-- =============================================
-- LUXURY STAY - Hotel Management System
-- Database Schema (MySQL)
-- =============================================

CREATE DATABASE IF NOT EXISTS luxury_stay CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE luxury_stay;

-- Bảng tài khoản (người dùng + nhân viên)
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(20),
  password VARCHAR(255) NOT NULL,
  role ENUM('customer', 'staff', 'admin') DEFAULT 'customer',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng danh mục phòng
CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng phòng (sản phẩm)
CREATE TABLE rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT,
  name VARCHAR(150) NOT NULL,
  room_number VARCHAR(20),
  floor INT DEFAULT 1,
  capacity INT DEFAULT 2,
  price_per_night DECIMAL(12,0) NOT NULL,
  area INT DEFAULT 25,
  description TEXT,
  image VARCHAR(255) DEFAULT 'default-room.jpg',
  status ENUM('available', 'occupied', 'maintenance') DEFAULT 'available',
  amenities TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Bảng đơn đặt phòng
CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_code VARCHAR(20) NOT NULL UNIQUE,
  user_id INT NOT NULL,
  total_amount DECIMAL(12,0) NOT NULL,
  payment_method ENUM('cash', 'bank', 'momo', 'vnpay', 'paypal') DEFAULT 'cash',
  payment_status ENUM('unpaid', 'paid') DEFAULT 'unpaid',
  status ENUM('pending', 'confirmed', 'checkedin', 'checkedout', 'cancelled') DEFAULT 'pending',
  guest_name VARCHAR(100),
  guest_phone VARCHAR(20),
  note TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Chi tiết đơn (phòng trong đơn)
CREATE TABLE order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  room_id INT NOT NULL,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  nights INT NOT NULL,
  price DECIMAL(12,0) NOT NULL,
  subtotal DECIMAL(12,0) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (room_id) REFERENCES rooms(id)
);

-- Dữ liệu mẫu
INSERT INTO users (full_name, email, phone, password, role) VALUES
('Admin System', 'admin@luxurystay.vn', '0900000001', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('Nhân viên A', 'staff@luxurystay.vn', '0900000002', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'staff'),
('Nguyễn Văn Khách', 'user@email.com', '0901234567', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer');
-- password mặc định: password
INSERT INTO users (full_name, email, phone, password, role) VALUES
('Nguyễn Văn An', 'nguyenvanan@gmail.com', '0901234567', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer');
INSERT INTO categories (name, description) VALUES
('Standard', 'Phòng tiêu chuẩn ấm cúng'),
('Deluxe', 'Phòng cao cấp rộng rãi'),
('Suite', 'Suite sang trọng view đẹp'),
('Presidential', 'Đỉnh cao sang trọng'),
('Family', 'Phòng gia đình rộng rãi'),
('Ocean View', 'Phòng view biển');

INSERT INTO rooms (category_id, name, room_number, floor, capacity, price_per_night, area, description, status, amenities) VALUES
(1, 'Phòng Standard', '101', 1, 2, 850000, 25, 'Phòng tiêu chuẩn đầy đủ tiện nghi cơ bản.', 'available', 'WiFi,TV,Điều hòa'),
(1, 'Phòng Standard', '105', 1, 2, 850000, 25, 'Phòng tiêu chuẩn ấm cúng.', 'occupied', 'WiFi,TV,Điều hòa'),
(2, 'Phòng Deluxe', '201', 2, 2, 1350000, 35, 'Phòng cao cấp với minibar và view đẹp.', 'available', 'WiFi,TV,Minibar,Điều hòa'),
(2, 'Phòng Deluxe', '205', 2, 2, 1350000, 35, 'Phòng Deluxe sang trọng.', 'occupied', 'WiFi,TV,Minibar,Điều hòa'),
(3, 'Phòng Suite', '501', 5, 4, 2500000, 55, 'Suite với jacuzzi và view biển.', 'occupied', 'WiFi,TV,Jacuzzi,View biển,Minibar'),
(4, 'Phòng Presidential', '701', 7, 4, 5000000, 90, 'Đỉnh cao sang trọng với butler 24/7.', 'available', 'WiFi,Bar riêng,Butler,Jacuzzi'),
(5, 'Phòng Gia đình', '402', 4, 5, 1800000, 45, 'Không gian rộng cho gia đình có trẻ nhỏ.', 'available', 'WiFi,TV,Kids area,Điều hòa'),
(6, 'Phòng Ocean View', '308', 3, 2, 2000000, 40, 'Ban công rộng với tầm nhìn biển.', 'available', 'WiFi,Ban công,View biển,TV');
