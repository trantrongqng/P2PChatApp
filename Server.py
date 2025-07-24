import asyncio
import websockets
import json

connected = set()

async def echo(websocket):
    print("✅ Client connected")
    connected.add(websocket)

    try:
        async for message in websocket:
            print("📩 Received:", message)

            try:
                data = json.loads(message)
            except json.JSONDecodeError:
                print("❌ Không phải JSON hợp lệ:", message)
                continue

            # Gửi lại cho các client khác
            disconnected = set()
            for conn in connected:
                if conn != websocket:
                    try:
                        await conn.send(json.dumps(data))
                    except:
                        disconnected.add(conn)

            # Loại bỏ client đã ngắt kết nối
            connected.difference_update(disconnected)

    except websockets.exceptions.ConnectionClosed:
        print("❌ Client disconnected")
    finally:
        connected.discard(websocket)

async def main():
    server = await websockets.serve(echo, "192.168.1.11", 12345,  max_size=None)
    print("✅ WebSocket server đang chạy tại ws://192.168.1.11:12345")
    await server.wait_closed()

asyncio.run(main())
