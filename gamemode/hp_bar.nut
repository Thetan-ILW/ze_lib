local healthBar = Entities.FindByClassname(null, "monster_resource");

SetPercent <- @(linear) NetProps.SetPropInt(healthBar, "m_iBossHealthPercentageByte", linear * 255.0);
Hide <- @() SetPercent(0);