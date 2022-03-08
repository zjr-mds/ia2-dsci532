library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(ggplot2)
library(plotly)

movie <- read.csv('data/movies_clean_df.csv') %>%
  select(-Title)


app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

app$layout(
  dbcContainer(
    list(
      dccGraph(id='plot-area'),
      dccDropdown(
        id='col-select',
        options = movie %>% 
          colnames() %>%
          purrr::map(function(col) list(label = col, value = col)), 
        value='IMDB.Rating')
    )
  )
)

app$callback(
  output('plot-area', 'figure'),
  list(input('col-select', 'value')),
  function(col) {
      p <- movie %>% 
        ggplot(aes(x = `Major.Genre`, y = !!sym(col), fill = `Major.Genre`)) +
        geom_boxplot()+
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
        ggplotly(p)
  }
)


app$run_server(host =  '0.0.0.0')