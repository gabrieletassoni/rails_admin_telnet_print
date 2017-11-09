class ReassignTemplates < ActiveRecord::Migration[4.2]
  def change
    # ["SingoloParticolareCommessa", "MultiParticolareCommessa", "SingoloParticolareCommessa", "SingoloParticolareCommessa"]
    transform = {
      "SingoloParticolareCommessa" => "Particolare Singolo",
      "MultiParticolareCommessa" => "Particolari Multipli",
      "MultiParticolareSovracollo" => "Stampa del Sovracollo"
    }
    transform.each_pair do |k,v|
      Printer.where(template: k).update_all(print_template_id: PrintTemplate.where(name: v).first.id)
    end
  end
end
