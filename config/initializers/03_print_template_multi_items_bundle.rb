class MultiParticolareSovracollo < PrintTemplate
  def self.description
    "Modello per la stampa di 15 particolari di sovracollo per Mobilart"
  end

  @TEMPLATE = "
  ^XA
  ^MDTEMPERATURE
  ^PW799
  ^LL1199

  ^BY2,3,40^FT80,73^BCN,,Y,N
  ^FD>:VAR00^FS					'Numero Sovracollo

  ^BY2,3,34^FT59,254^BCN,,Y,N
  ^FD>:BARCODE00^FS				'Particolare 1

  ^BY2,3,34^FT59,314^BCN,,Y,N
  ^FD>:BARCODE01^FS				'Particolare 2

  ^BY2,3,34^FT59,376^BCN,,Y,N
  ^FD>:BARCODE02^FS				'Particolare 3

  ^BY2,3,34^FT59,441^BCN,,Y,N
  ^FD>:BARCODE03^FS				'Particolare 4

  ^BY2,3,34^FT59,502^BCN,,Y,N
  ^FD>:BARCODE04^FS				'Particolare 5

  ^BY2,3,34^FT59,561^BCN,,Y,N
  ^FD>:BARCODE05^FS				'Particolare 6

  ^BY2,3,34^FT59,624^BCN,,Y,N
  ^FD>:BARCODE06^FS				'Particolare 7

  ^BY2,3,34^FT59,689^BCN,,Y,N
  ^FD>:BARCODE07^FS				'Particolare 8

  ^BY2,3,34^FT59,758^BCN,,Y,N
  ^FD>:BARCODE08^FS				'Particolare 9

  ^BY2,3,34^FT59,821^BCN,,Y,N
  ^FD>:BARCODE09^FS				'Particolare 10

  ^BY2,3,34^FT59,888^BCN,,Y,N
  ^FD>:BARCODE10^FS				'Particolare 11

  ^BY2,3,34^FT59,947^BCN,,Y,N
  ^FD>:BARCODE11^FS				'Particolare 12

  ^BY2,3,34^FT59,1012^BCN,,Y,N
  ^FD>:BARCODE12^FS				'Particolare 13

  ^BY2,3,34^FT59,1076^BCN,,Y,N
  ^FD>:BARCODE13^FS				'Particolare 14

  ^BY2,3,34^FT59,1141^BCN,,Y,N
  ^FD>:BARCODE14^FS
  ^BY
  ^PQ1
  ^XZ
"
  @NUMBEROFBARCODES = 15
  # Solo per l'header, quando trovo la key,
  # allora invio il valore come metodo del modello di partenza
  @TRANSLATIONMATRIX = {
    "VAR00" => "bundle.code",
  }
end
