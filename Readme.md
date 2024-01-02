# Aplikacja do śledzenia rynku Forex

Funkcjonalności:
- Wykresy świecowe z mozliwoscia sprawdzenia cen otwarcia, zamknięcia oraz najwyszej i najnizszej ceny w danym dniu dla okreslonej waluty
- Wykresy liniowe stworzono przy wykorzystaniu SwiftUICharts
- Tabela z obecnymi kursami walut i mozliwoscia sprawdzenia procentowego wzrostu/spadku 
- Prawdziwe kursy walut pobierane przez api raz dziennie i cache'owane w pamięci telefonu (w postaci plików csv) - by nie przekroczyc dziennego limitu zapytan - 40
- Konwerter dla wybranych par walut 
- Napis informujący o ładowaniu, jeżeli sieć będzie niestabilna i potrzebny będzie dłuższy czas na pobranie danych - pobieranie asynchroniczne
- Mozliwosc wyboru jezyka (angielski/polski)
- Mozliwosc wyboru motywu kolorystycznego - light/dark
- Informacje o autorze i stronach źródłowych
