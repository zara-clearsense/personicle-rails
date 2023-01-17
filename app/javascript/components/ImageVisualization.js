import React from 'react'
import { useState, useEffect } from "react";
import SimpleImageSlider from "react-simple-image-slider";
// import { Chrono } from "react-chrono";
// import { KeyboardControlKey } from '@mui/icons-material';
import Modal from '@mui/material/Modal';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';

import Typography from '@mui/material/Typography';
import Image from "material-ui-image";
const style = {
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  width: "43%",
  bgcolor: 'background.paper',
  border: '2px solid #000',
  boxShadow: 24,
  p: 4,
};
function ImageVisualization ({user_id, image_urls, tag, auth}){
  const [open, setOpen] = useState(false);
  const [modalData, setData] = useState();
  const handleClose = () => setOpen(false);
    const imagesForTag = Object.keys(image_urls)
                        .filter(key => key == tag)
                        .reduce((obj,key) => {
                          return {
                            ...obj,
                            [key]: image_urls[key]
                          }
                        }, {});
    // console.log(imagesForTag)
    var urls_array = []
    var urls_array_temp = []

    const urls = Object.entries(imagesForTag).forEach(obj => {
      obj[1].forEach (val => {
        urls_array.push([val[1],val[2]])
        urls_array_temp.push(val[2])
      })
    })

const images = urls_array.sort(([a], [b]) => {
  return a - b;
});
var timestamp = [];
var images_url = [];
images.forEach( im => {
  timestamp.push(im[0]);
  images_url.push(im[1]);
});
// var items = [];
//  images.forEach( im => {
//    items.push({
//      title: im[0],
//      media: {
//       type: "IMAGE",
//       source: {
//         url: im[1]
//       }
//      }
//    })
//  })


// console.log(items)

const handleOpen = (idx) => {
  setData({
    time: timestamp[idx],
    url: images_url[idx]
  });
  setOpen(true);

}
const deleteImage = (imageUrl) => {
  console.log(imageUrl)
  const url = new URL(imageUrl);
  const key = url.pathname.split("/")[2];
  var result = confirm("Are you sure you want to delete this image?");
  if(result){
    $.ajax({
      type: "POST",
      url: "/image/delete",
      data : {
        "image_key": key,
        "question_id": tag
      },
      complete: function () {
        alert("Image is marked for deletion and will be deleted")
      }
    });
  }
}

const ImageModal = () => {
  return modalData ? (
    <Modal
    open={open}
    onClose={handleClose}
    aria-labelledby="modal-modal-title"
    aria-describedby="modal-modal-description"
  >
    <Box sx={style}>
          <Typography id="modal-modal-title" variant="h6" component="h2">
           Time: {modalData.time}
          </Typography>
          {/* <Typography id="modal-modal-description" sx={{ mt: 2 }}>
           Patient description: 
          </Typography> */}
          <Image src={modalData.url} style={{ border: '3px solid #5e72e4'}}/>
          <Button onClick={() => {
            deleteImage(modalData.url);
          }} 
          >
            Delete
          </Button>
          {/* <Typography id="modal-modal-description" sx={{ mt: 2 }}> */}
            {/* {modalData} */}
          {/* </Typography> */}
        </Box>
   </Modal>
  ) : null;
}
return (
    
  <div className="mt-2" >
     <ImageModal />
    <SimpleImageSlider
      width="95%"                   
      height="68%"
      images={urls_array_temp}
      showBullets={true}
      showNavs={true}
      onClick ={(idx,event) => handleOpen(idx)}
    />

  {/* <Chrono items={items} mode="HORIZONTAL"  onItemSelected={handleClick(items)}/> */}
  </div>
);

}
export default ImageVisualization; 