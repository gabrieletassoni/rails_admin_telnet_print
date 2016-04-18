class SingoloParticolareCommessa < PrintTemplate
  def self.description
    "Modello per la stampa di un singolo particolare di commessa per Mobilart"
  end

  @TEMPLATE = "
^XA
^MDTEMPERATURE
^PW559
^LL0296
^FT279,54^A0N,28,28^FH\^FD VAR00 ^FS  			    'Varibile codice commessa
^FT278,107^A0N,28,28^FH\^FD VAR01^FS			      'Variabile codice ponte
^FT28,53^A0N,28,28^FH\^FDCODICE COMMESSA:^FS	'Campo Fisso
^FT279,159^A0N,28,28^FH\^FD VAR02^FS			      'Variabile Cod Stanza
^FT27,107^A0N,28,28^FH\^FDCODICE PONTE:^FS   	'Campo Fisso
^FT25,159^A0N,28,28^FH\^FDCODICE STANZA:^FS		'Campo Fisso
^FT279,209^A0N,28,28^FH\^FD VAR03 ^FS	        'Variabile Codice Stanza
^FT24,212^A0N,28,28^FH\^FDCODICE MOBILE:^FS		'Campo Fisso
^BY1,3,44^FT64,272^BCN,,Y,N				            'Ini Barcode
^FD>:BARCODE00^FS					                    'COMMESSA+PONTE+STANZA+MOBILE+NRUNIV
^PQ1							                            'Quantità
^XZ
"
  @NUMBEROFBARCODES = 1
  # Solo per l'header, quando trovo la key,
  # allora invio il valore come metodo del modello di partenza
  @TRANSLATIONMATRIX = {
    "VAR00" => "chosen_furniture.chosen_room.chosen_deck.commission.name",
    "VAR01" => "chosen_furniture.chosen_room.chosen_deck.name",
    "VAR02" => "chosen_furniture.chosen_room.name",
    "VAR03" => "chosen_furniture.name",
  }
end
