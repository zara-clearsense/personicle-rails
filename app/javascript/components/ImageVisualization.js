import React from 'react'
import { useState, useEffect } from "react";
import SimpleImageSlider from "react-simple-image-slider";
function ImageVisualization ({user_id, image_urls, tag, auth}){

    const imagesForTag = Object.keys(image_urls)
                        .filter(key => key == tag)
                        .reduce((obj,key) => {
                          return {
                            ...obj,
                            [key]: image_urls[key]
                          }
                        }, {});

    var urls_array = []
    const urls = Object.entries(imagesForTag).forEach(obj => {
      obj[1].forEach (val => {
        urls_array.push(val[2])
      })
    })

const images = urls_array


return (
  <div className="mt-2" >
    <SimpleImageSlider
      width="95%"
      height="68%"
      images={images}
      showBullets={true}
      showNavs={true}
    />
  </div>
);
}
export default ImageVisualization;