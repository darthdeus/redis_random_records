class Loan < Ohm::Model
  ATTRIBUTES = %w{name description status funded_amount basket_amount image activity sector use location partner_id posted_date planned_expiration_date loan_amount borrower_count}

  ATTRIBUTES.each do |attr|
    attribute attr
  end
  index :name

  def to_hash
    # join all attributes in a hash
    attributes = ATTRIBUTES.inject({}) do |hash, key|
      value = self.send(key)
      # even though this is ugly, it's the simplest way to convert Hash in a String to JSON
      if %w{description image location}.include?(key)
        value = eval(value)
      end

      attr_hash = { key.to_sym => value }
      hash.merge attr_hash
    end
    super.merge(attributes)
  end
end