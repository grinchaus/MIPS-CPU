# MIPS Single-Cycle CPU (Verilog)

Реализация однотактного процессора MIPS с поддержкой подмножества инструкций на Verilog. Проект включает модули памяти, регистрового файла и управляющего устройства.

---

## Структура проекта

| Модуль                     | Файл                          | Назначение                                                                 |
|----------------------------|-------------------------------|----------------------------------------------------------------------------|
| Память команд/данных       | [memory.v](./memory.v)        | Асинхронное чтение, синхронная запись. Инициализируется из бинарных файлов. |
| Регистровый файл           | [register_file.v](./register_file.v) | 32 регистра общего назначения (чтение асинхронное, запись по фронту CLK). |
| 32-битный регистр PC       | [d_flop.v](./d_flop.v)        | Хранит значение Program Counter.                                          |
| Ядро процессора            | [mips_cpu.v](./mips_cpu.v)    | Управляющее устройство + ALU. Основная логика процессора.                 |
| Тестовый стенд             | [cpu_test.v](./cpu_test.v)    | Пример тестирования с выводом состояния регистров и памяти.              |

---

## Ограничения
- **Запрещено**: Переименовывать модули, порты, файлы (нарушение ведет к ССЗБ).
- **Разрешено**: Изменять типы портов (например, `output reg` вместо `output`).

---

## Реализованные инструкции

### Часть 1: Базовые (8 баллов)
- **R-тип**: `add`, `sub`, `and`, `or`, `slt` (`opcode=0x00`, `funct=0x20-0x2A`).
- **I-тип**: `lw` (`opcode=0x23`), `sw` (`opcode=0x2B`), `beq` (`opcode=0x04`).

### Часть 2: Дополнительные I-тип (4 балла)
- `addi` (`opcode=0x08`), `andi` (`opcode=0x0C`), `bne` (`opcode=0x05`).

### Часть 3: J-тип (6 баллов)
- `j` (`opcode=0x02`), `jal` (`opcode=0x03`), `jr` (`opcode=0x00`, `funct=0x08`).

---

## Сборка и тестирование
1. Компиляция:
   ```bash
   iverilog -o out cpu_test.v mips_cpu.v memory.v register_file.v d_flop.v util.v
   ```
2. Запуск тестов:
   ```bash
   vvp out 
   ```
3. Примеры программ: programs_samples.

## Примечания
-Память данных и регистры инициализируются нулями.
-Управляющее устройство генерирует сигналы для ALU, MemWrite и RegDst.
-Тесты покрывают все инструкции из задания.
