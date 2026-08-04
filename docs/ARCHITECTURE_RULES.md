# AI Core OS v1.1 - Architecture Rules
- MemoryStore و VectorStore منفصلين
- Isar generated files محفوظة في Git
- isar_generator يولد محليا فقط عبر tool/generate_isar.sh
- ChatRuntime قابل للاستبدال Fake <-> Fllama
- Kernel لا يعرف تفاصيل Isar/Drift/Fllama
