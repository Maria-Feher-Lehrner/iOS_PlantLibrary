# iOS_PlantLibrary
An indoor-plants management app as final project for iOS advanced class.

*****Finales Projekt iOS Advanced*****

FH Academy Lehrgang Web- und Appdevelopment
Studentin: Maria Feher-Lehrner

Inhalt:

Die App "Plant Base" ist eine Phytothek für Zimmerpflanzen.


+++++ABGABE INFOS++++
**Funktionen:**
- Die User:in kann Räume (Core Data Entities 'Locations') und Pflanzen (Core Data Entities 'Plants') hinzufügen und bearbeiten
- Die App sendet Notifications als Erinnerung zum Gießen und Düngen nach vorbestimmten Intervallen - abhängig vom Bedarf (siehe Attribute) der Pflanzen
- Die App zeigt den Status jeder Pflanze bezüglich ihres Wasser-, Dünger- und Lichtbedarfs an. (--> in der Listenübersicht PlantsView)
- Die User:in kann (jederzeit, aber erinnert durch einen Reminder) den Wasser- und Düngerstatus auf OK setzen.
- Der Wasser- / Düngerstatus wird anlässlich des nächsten Reminders wieder auf ungenügend zurückgesetzt und im UI übernommen.


**Einbindung Lernstoff:**
- Core Data
- Localisation (Deutsch und Englisch, Konsolenoutputs ausgenommen)
- Local Notifications (Gieß- & Düngereminder)
- mittels Notification Center
- Photopicker (--> unter neue Pflanze erstellen (PlantRegistrationView) oder unter Pflanzen-Detailansicht (PlantprofileView))
- Animationen (--> wenn in der Pflanzendetailansicht (PlantprofileView) der Toggle für Wasser oder Fertilizer auf isOn gesetzt wird.)


**Testing-/Development "Features":**
- Im Projekt gibt es in der StartView zwei Buttons, die zum Testen der Notifications einkommentiert werden können, da das "echte" Intervall (jeden Mittwoch und Sonntag) sonst zu lang wäre.
- Es sind außerdem schon erste Beispieldaten über den Controller hardgecoded-eingefügt, damit man beim Starten der App zum Testen sofort etwas sieht. Die Core Data können - ebenfalls mit Hilfe einer reinen debugging-testing Funktion im top level Project-Base file wieder bereinigt werden.
