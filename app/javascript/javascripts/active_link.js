document.addEventListener('turbolinks:load', () => {
  const path = window.location.pathname.split('/')
  // frontstage
  let nodes = document.querySelectorAll(`a[data-active='${path[1]}']`)
  nodes.forEach(node => node.classList.add('active'))
  // account/admin/users
  nodes = document.querySelectorAll(`a[data-active='${path[1]}-${path[2]}']`)
  nodes.forEach(node => node.classList.add('active'))
})
