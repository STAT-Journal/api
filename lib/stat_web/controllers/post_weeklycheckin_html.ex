defmodule StatWeb.PostWeeklyCheckInHTML do
  use StatWeb, :html

  def valence_radio_input_id(assigns) do
    "valence-#{assigns.value}"
  end

  def valence_radio_input(assigns) do
    ~H"""
    <input
      name="weekly_check_in[valence]"
      id={valence_radio_input_id(assigns)}
      class="hidden peer"
      type="radio"
      value={assigns.value}
      />
    """
  end

  def valence_radio_label(assigns) do
    ~H"""
    <label for={valence_radio_input_id(assigns)} class="block items-center w-full p-2 text-gray-500 bg-white border border-gray-200 rounded-lg cursor-pointer dark:hover:text-gray-300 dark:border-gray-700 dark:peer-checked:text-blue-500 peer-checked:border-blue-600 peer-checked:text-blue-600 hover:text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:bg-gray-800 dark:hover:bg-gray-700">
      <div class="text-center text-3xl"><%= assigns.value %></div>
    </label>
    """
  end

  def valence_radio_item(assigns) do
    ~H"""
    <li>
      <.valence_radio_input value={assigns.value} label={assigns.label} />
      <.valence_radio_label value={assigns.value} label={assigns.label} />
    </li>
    """
  end

  def valence_radio_list(assigns) do
    ~H"""
    <h3 class="text-lg text-center font-medium text-gray-900 dark:text-white">
      Rate your mood
    </h3>
    <ul class="grid w-full gap-6 md:grid-cols-5">
      <%= for {value, label} <- Ecto.Enum.mappings(Stat.Posts.WeeklyCheckIn, :valence) do %>
        <.valence_radio_item value={value} label={label} />
      <% end %>
    </ul>
    """
  end

  embed_templates "post_weeklycheckin_html/*"
end
