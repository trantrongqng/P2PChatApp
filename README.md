# 📨 P2PChatApp
Đây là ứng dụng nhắn tin **Peer-to-Peer** sử dụng **Qt (C++/QML)** kết hợp **Python WebSocket server**.  
Ứng dụng cho phép người dùng trò chuyện trong mạng LAN thông qua WebSocket.
---

## 🚀 Cách sử dụng

### ⚙️ Yêu cầu

- Python 3 đã cài sẵn
- Đã cài Qt 6.9.1 + Qt Creator
- pip install websockets` (nếu chưa có)

### ▶️ Chạy ứng dụng

**Cách 1: Dùng script tự động**
run_all.bat
Trong cửa sổ ứng dụng, nhập địa chỉ IP của máy đang chạy server
Ví dụ:
ws://192.168.1.11:12345
⚠️ Lưu ý: IP sẽ thay đổi tùy máy. Bạn cần nhập đúng IP nội bộ của máy chủ

Nhập tên người dùng → Nhấn "Đăng nhập" để bắt đầu chat
**Cách 2: Tự chạy thủ công
Mở cmd: 
cd Server
python server.py
Sau đó chạy Qt app trong Qt Creator (hoặc bấm Ctrl+R)
