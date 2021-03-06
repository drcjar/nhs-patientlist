class PatientDetail
  extend Forwardable

  def_delegators :@admission, :currward, :admconsultcode
  def_delegators :@patient, :hospno, :name, :birthdate, :sex, :pmh, :allergies, :firstnames, :lastname, :pastmedhx, :pat_id, :pendings, :to_dos, :risk_level, :risk_level=

  alias :ward :currward
  alias :pmh :pastmedhx
  alias :patient_id :pat_id

  attr_reader :patient, :admission

  def self.admitted
    Admission.admitted.map{|a| PatientDetail.new(a)}
  end
  def self.in_ward(ward)
    Admission.admitted.where(:currward=>ward).map{|a| PatientDetail.new(a)}
  end

  def initialize(admission)
    @admission = admission
    @patient = admission.patient

    if @patient.risk_level_events.empty?
      @patient.risk_level = "low"
    end
  end

  def name
    "#{firstnames} #{lastname}"
  end

  def consultant_name
    if @admission.consultant
      @admission.consultant.consultname
    else
      @admission.admconsultcode
    end
  end
end
