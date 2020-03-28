// Using attributes from current script tag
// 'data-selector': html selector for choose which input should become datetime-picker
// 'data-options': options for datetime-picker

import flatpickr from 'flatpickr/dist/flatpickr'
import i10n from 'flatpickr/dist/l10n/zh-tw'

const script = document.currentScript
const selector = script.getAttribute('data-selector')
if (selector == null) throw new Error('<script> tag must have attribute "data-selector"')

const dom = document.querySelector(selector)
const options = { locale: i10n.zh_tw, ...JSON.parse(script.getAttribute('data-options')) }
flatpickr(dom, options)