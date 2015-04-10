module PolicyHelpers

  def check_nation_applicability(policy, nation)
    nation = nation.downcase.gsub(' ', '_')
    policy.send(nation) == true

    policy.inapplicable_nations.each do |n|
      policy.send("#{nation}_policy_url") == "http://www.#{nation}policyurl.com"
    end
  end

end

World(PolicyHelpers)
