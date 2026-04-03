# PE-Algorithm Source Code

Deze repository bevat de broncode voor het testen en benchmarken van sorteeralgoritmes in Python en Lua.

## Inhoud van de repository

De repository bevat prototypes van de algoritmes **Merge Sort** en **Quick Sort**, oorspronkelijk geschreven in **C#**. Deze prototypes zijn eerst gebruikt om de sorteeralgoritmes te ontwikkelen en te testen, voordat ze zijn geïmplementeerd in **Lua** en **Python**.

In de map `src` staan de daadwerkelijke implementaties van **Merge Sort** en **Quick Sort** voor Lua en Python. Daarnaast bevat deze map ook de **instrumented** versies. Deze versies zijn bedoeld om de prestaties van de algoritmes zelf te meten. Voor het onderzoek zijn deze echter minder relevant, omdat de focus ligt op de prestaties van de volledige programmeertaal en niet alleen op het algoritme.

## Vereisten

Om de testen uit te voeren heb je het volgende nodig:

- een shell-omgeving
- [Hyperfine](https://github.com/sharkdp/hyperfine)


## Benchmark uitvoeren
Ga eerst naar de map `src`. Vanuit daar kun je het benchmarkscript uitvoeren met:


./benchmark.sh

Op Linux moet je mogelijk eerst uitvoerrechten geven aan het script:

chmod +x benchmark.sh

Daarna kun je het benchmarkprogramma starten.

## Werking van het benchmarkprogramma

Na het opstarten krijg je een menu te zien waarin je stap voor stap je keuzes maakt:

Kies of je de benchmark wilt uitvoeren met Hyperfine of met de instrumented versie.
Kies of je wilt testen met Python, Lua of beide talen.
Kies het type dataset dat je wilt gebruiken:
Uniform Random
Nearly Sorted
Sorted
Reverse Sorted
Kies ten slotte welk sorteeralgoritme je wilt gebruiken:
Merge Sort
Quick Sort

## Zelf data genereren
Als je zelf data wilt genereren, kun je hiervoor de numbergenerator gebruiken. Deze maakt automatisch een Data map aan met datasets van verschillende groottes.


