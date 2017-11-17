$(document).ready(function() {
  $("*[data-taggable='true']").each(function() {
    $(this).select2({
      tags: true,
      theme: "bootstrap",
      width: "100%",
      minimumInputLength: 1,
      language: I18n.locale,
      placeholder: I18n.t('offers.form.add_a_key_word'),
      // maximumSelectionLength: 10,
      tokenSeparators: [',', ' ', ';', ':', '.'],
      ajax: {
        url: "/tags",
        dataType: 'json',
        delay: 100,
        noLoader: true,
        data: function (params) {
          return {
            name: params.term,
            tags_chosen: $(this).val(),
            taggable_type: $(this).data("taggable-type"),
            context: $(this).data("context"),
            page: params.page
          }
        },
        processResults: function (data, params) {
          params.page = params.page || 1;
          return {
            results: $.map(data, function (item) {
              return {
                text: item.name,
                id: item.name
              }
            })
          };
        },
        cache: true
      }
    });
  });
});

$(document).on('select2:select select2:unselect', "*[data-taggable='true']", function() {
  var taggable_id = $(this).attr('id');
  // genre_list_select2 --> genre_list
  var hidden_id = taggable_id.replace("_select2", "");
  // film_*genre_list* ($= jQuery selectors ends with)
  var hidden = $("[id$=" + hidden_id + "]");
  // Select2 either has elements selected or it doesn't, in which case use []
  var joined = ($(this).val() || []).join(",");
  hidden.val(joined);
});
