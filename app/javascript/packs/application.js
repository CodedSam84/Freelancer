// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require('packs/star-rating-svg')

window.Noty = require('noty');
const { Dropzone } = require('dropzone');
window.bulmaCarousel = require('bulma-extensions/bulma-carousel/dist/js/bulma-carousel');


$(document).on('turbolinks:load', () => {
	$('.toggle').on('click', (e) => {
		e.stopPropagation();
		e.preventDefault();
		$('#' + e.target.getAttribute('aria-controls')).toggleClass('is-hidden');
	})
})

require("trix")
require("@rails/actiontext")