# frozen_string_literal: true

# Format dates for display
class DateFacetItemPresenter < Blacklight::FacetItemPivotPresenter
  def label
    year, month, date = value.split('-')

    if date
      date.to_i.ordinalize
    elsif month
      Date.parse("#{year}-#{month}-01").strftime('%B')
    else
      year
    end
  end

  def constraint_label
    year, month, date = value.split('-')

    if date
      Date.parse(value).strftime('%B %e, %Y')
    elsif month
      Date.parse("#{year}-#{month}-01").strftime('%B %Y')
    else
      year
    end
  end
end
