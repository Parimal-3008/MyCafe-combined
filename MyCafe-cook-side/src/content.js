import React from 'react'
import "./content.css"
function Content(props) {
  return (
    <div className='contentparent'>{props.ordercontent}</div>
  )
}

export default Content