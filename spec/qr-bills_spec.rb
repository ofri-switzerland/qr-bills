require 'qr-bills'

RSpec.describe QRBills do
  describe "init" do
    it "raise an exception if the bill kind is not set" do
      expect { QRBills.generate({}) }.to raise_error(ArgumentError, "QR-bill invalid parameters: bill type param not set")
    end

    it "raise an exception if currency is not set" do
      expect { QRBills.generate(bill_type: "bad") }.to raise_error(ArgumentError, "QR-bill invalid parameters: currency cannot be blank")
    end

    it "raise an exception if bill type is not supported" do
      expect { QRBills.generate(bill_type: "bad", bill_params: { currency: 'CHF' }) }.to raise_error(ArgumentError, "QR-bill invalid parameters: bill type is not supported")
    end
  end

  describe "generate" do
    let(:params) do
      params = QRBills.get_qr_params
      params[:bill_type] = QRBills.get_qrbill_with_creditor_reference_type
      params[:qrcode_format] = 'svg'
      params[:output_params][:format] = 'prawn'
      params[:bill_params][:creditor][:iban] = "CH9300762011623852957"
      params[:bill_params][:creditor][:address].merge!(name: "Compagnia di assicurazione", line1: "Via cantonale", line2: "24", postal_code: "3000", town: "Lugano", country: "CH")
      params[:bill_params][:debtor][:address].merge!(name: "Foobar Barfoot", line1: "Via cantonale", line2: "25", postal_code: "3001", town: "Comano", country: "CH")
      params[:bill_params][:amount] = 12345.15
      params[:bill_params][:reference] = "RF89MTR81UUWZYO48NY55NP3"
      params[:bill_params][:reference_type] = "SCOR"
      params
    end

    it "adds the locale files to the I18n load path once" do
      QRBills.generate(params, Prawn::Document.new(page_size: 'A4'))

      expect { QRBills.generate(params, Prawn::Document.new(page_size: 'A4')) }.not_to(change { I18n.load_path.size })
    end
  end
end
