/**
 * Created by Joe on 6/5/2017.
 */

$(function(){
    var page = 1;
    var a;

    setPage = function (value) {
        page = value;
        a = new App();
    };

// model
    var Quote = Backbone.Model.extend({
        defaults: {
            quote: "No quote",
            context: "No context",
            source: "No source",
            theme: "No theme"
        }
    });

// collection
    var QuoteCollection = Backbone.Collection.extend({
        defaults: {
            model: Quote
        },
        model: Quote,
        url: 'https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json'

    });

// view

    var QuotesView = Backbone.View.extend({
        tagName: 'ul',

        initialize: function(){
            this.listenTo(this.model, 'change', this.render);
        },
        render: function(){
            this.$el.html('<b>' + this.model.get('source') + ' from <i>' + this.model.get('context') + '</i></b><li><b>Quote: "</b>' + this.model.get('quote') + '"</li>');
            return this;
        },

    });

    var App = Backbone.View.extend({
        el: $('#main'),

        initialize: function(){
            var quoteList = new QuoteCollection(),
                quotes = $(this.el).find('#quotes'),
                quotesView;

            var perPage = 15 * page;
            var counter = 0;
            var minimum = 15 * (page - 1);


            var clearInner = document.getElementById("quotes");
            // clear old sub-elements
            while(clearInner.firstChild){
                clearInner.removeChild(clearInner.firstChild);
            }

            quoteList.fetch({
                success: function(collection){
                    collection.each(function (model){
                        if(counter < perPage && counter >= minimum && page < 4) {
                            quotesView = new QuotesView({
                                model: model
                            });


                            quotes.append(quotesView.render().el);
                        }
                        counter++;
                        if(page === 4 && model.attributes.theme === "games"){
                            quotesView = new QuotesView({
                                model: model
                            });


                            quotes.append(quotesView.render().el);
                        }
                        if(page === 5 && model.attributes.theme === "movies"){
                            quotesView = new QuotesView({
                                model: model
                            });


                            quotes.append(quotesView.render().el);
                        }



                        //page2 = quoteList.pagination(15, 2);
                        //page3 = quoteList.pagination(15, 3);

                       /* page1.forEach(function(model){
                            quotesView = new QuotesView({
                                model: model
                            });
                            quotes.append(quotesView.render().el);
                        });*/

                    });
                    //console.log(page1);
                    //console.log(page2);
                    //console.log(page3);
                }
            });

/*            quoteList.fetch({
                success: function(collection){
                    collection.each(function (model){
                        quotesView = new QuotesView({
                            model:model
                        });
                        console.log(quoteList.pagination(15, 2));

                        quotes.append(quotesView.render().el);
                    });
                }
            });*/
        },

        render: function(){
            return this;
        }
    });

    a = new App();

});




