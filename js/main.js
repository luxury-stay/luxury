// ========== AUTH (localStorage simulation + PHP ready) ==========
function getUser() {
  return JSON.parse(localStorage.getItem('user') || 'null');
}
function setUser(u) {
  localStorage.setItem('user', JSON.stringify(u));
}
function logout() {
  localStorage.removeItem('user');
  localStorage.removeItem('cart');
  window.location.href = 'login.html';
}
function requireAuth(roles) {
  const u = getUser();
  if (!u) {
    alert('Vui lòng đăng nhập để tiếp tục!');
    window.location.href = 'login.html';
    return false;
  }
  if (roles && !roles.includes(u.role)) {
    alert('Bạn không có quyền truy cập trang này!');
    window.location.href = 'index.html';
    return false;
  }
  return true;
}
function updateNav() {
  const u = getUser();
  const loginBtn = document.getElementById('navLogin');
  const userInfo = document.getElementById('navUser');
  if (loginBtn && userInfo) {
    if (u) {
      loginBtn.style.display = 'none';
      userInfo.style.display = 'flex';
      userInfo.innerHTML = `<span style="color:#c9a227;font-weight:600;">${u.name}</span>
        <a href="#" onclick="logout();return false;" style="color:#fff;margin-left:10px;font-size:0.85rem;">Đăng xuất</a>`;
    } else {
      loginBtn.style.display = 'block';
      userInfo.style.display = 'none';
    }
  }
  // Admin link
  const adminLink = document.getElementById('navAdmin');
  if (adminLink) {
    adminLink.style.display = (u && (u.role === 'staff' || u.role === 'admin')) ? 'block' : 'none';
  }
  updateCartCount();
}

// ========== ROOMS DATA ==========
const rooms = [
  { id:1, name:'Phòng Standard #101', type:'Standard', price:850000, capacity:2, area:25, image:'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=600', amenities:'WiFi,TV,Điều hòa', status:'available', desc:'Phòng tiêu chuẩn ấm cúng, đầy đủ tiện nghi.' },
  { id:2, name:'Phòng Deluxe #201', type:'Deluxe', price:1350000, capacity:2, area:35, image:'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=600', amenities:'WiFi,TV,Minibar,Điều hòa', status:'available', desc:'Phòng cao cấp với minibar và view đẹp.' },
  { id:3, name:'Phòng Suite #501', type:'Suite', price:2500000, capacity:4, area:55, image:'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=600', amenities:'WiFi,Jacuzzi,View biển,Minibar', status:'available', desc:'Suite sang trọng với jacuzzi và view biển.' },
  { id:4, name:'Phòng Presidential #701', type:'Presidential', price:5000000, capacity:4, area:90, image:'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=600', amenities:'Bar riêng,Butler,Jacuzzi,WiFi', status:'available', desc:'Đỉnh cao sang trọng với butler 24/7.' },
  { id:5, name:'Phòng Gia đình #402', type:'Family', price:1800000, capacity:5, area:45, image:'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=600', amenities:'WiFi,Kids area,TV,Điều hòa', status:'available', desc:'Không gian rộng cho gia đình có trẻ nhỏ.' },
  { id:6, name:'Phòng Ocean View #308', type:'Ocean View', price:2000000, capacity:2, area:40, image:'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?w=600', amenities:'Ban công,View biển,WiFi,TV', status:'available', desc:'Ban công rộng với tầm nhìn biển xanh.' }
];

// ========== CART ==========
function getCart() { return JSON.parse(localStorage.getItem('cart') || '[]'); }
function saveCart(c) { localStorage.setItem('cart', JSON.stringify(c)); updateCartCount(); }
function updateCartCount() {
  const total = getCart().reduce((s,i) => s + (i.qty||1), 0);
  document.querySelectorAll('.cart-badge').forEach(el => el.textContent = total);
}
function addToCart(roomId, checkin, checkout) {
  if (!requireAuth(['customer','staff','admin'])) return;
  const room = rooms.find(r => r.id === roomId);
  if (!room) return;
  const nights = Math.max(1, Math.ceil((new Date(checkout) - new Date(checkin)) / 86400000));
  let cart = getCart();
  // remove existing same room
  cart = cart.filter(i => i.id !== roomId);
  cart.push({ id: room.id, name: room.name, type: room.type, price: room.price, image: room.image, checkin, checkout, nights, qty: 1 });
  saveCart(cart);
  alert('Đã thêm "' + room.name + '" vào giỏ đặt phòng!');
}
function removeFromCart(id) {
  saveCart(getCart().filter(i => i.id !== id));
  if (typeof renderCart === 'function') renderCart();
}
function formatPrice(n) { return Number(n).toLocaleString('vi-VN') + 'đ'; }

// ========== RENDER ROOMS ==========
function renderRooms(list, containerId) {
  const el = document.getElementById(containerId);
  if (!el) return;
  if (!list.length) {
    el.innerHTML = '<p style="text-align:center;grid-column:1/-1;color:#999;">Không tìm thấy phòng</p>';
    return;
  }
  el.innerHTML = list.map(r => `
    <div class="room-card">
      <div style="position:relative;">
        <img src="${r.image}" alt="${r.name}">
        <span class="badge-type">${r.type}</span>
      </div>
      <div class="body">
        <h5>${r.name}</h5>
        <div class="amenities">
          <span><i class="bi bi-people"></i> ${r.capacity} người</span>
          <span><i class="bi bi-rulers"></i> ${r.area}m²</span>
        </div>
        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:10px;">
          <div class="price">${formatPrice(r.price)}<span>/đêm</span></div>
          <a href="room-detail.html?id=${r.id}" class="btn btn-primary btn-sm">Chi tiết</a>
        </div>
      </div>
    </div>
  `).join('');
}

// ========== ORDERS ==========
function getOrders() { return JSON.parse(localStorage.getItem('orders') || '[]'); }
function saveOrders(o) { localStorage.setItem('orders', JSON.stringify(o)); }

document.addEventListener('DOMContentLoaded', updateNav);
