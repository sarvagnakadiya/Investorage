import React from "react";
import { useState } from "react";
import "./home.css";
import { useNavigate } from "react-router-dom";
// import { ParallaxHover } from "react-parallax-hover";
import Navbar from "./navbar";
import BG from "../../images/bg.svg";
import TopBox from "../../images/top right box.svg";
import Line1 from "../../images/line abstract 1.svg";
import Line2 from "../../images/line abstract 2.svg";
import Line3 from "../../images/line abstract 3.svg";
import BtnImg from "../../images/button.svg";
import BtnArrow from "../../images/Arrow.svg";
import Asset1 from "../../images/Asset 1.svg";
import Asset2 from "../../images/Asset 2.svg";
import Spotify from "../../images/spotify.svg";
import gear from "../../images/gear.png";
import Uni from "../../images/uniswap.png";
import logo from "../../images/Investorage.png";
import AAVE from "../../images/aave.png";
import AppleTV from "../../images/appletv.svg";
import compoundDao from "../../images/compoundDao.png";

const Home = () => {
  const [newButton, setNewButton] = useState({ hidden: false });
  const navigate = new useNavigate();
  const takeToPlayer = () => {
    setNewButton({ hidden: true });
    setTimeout(navigate("/signup"), 3000);
  };
  return (
    <>
      {/* <Navbar /> */}
      <div
        className="home"
        style={{
          backgroundImage: `url(${BG}`,
          backgroundRepeat: "no-repeat",
          backgroundSize: "cover",
          width: "100%",
          height: "100%",
        }}
      >
        <section className="home-top">
          <div className="home-main">
            <div className="home-content-main">
              <div className="home-logo">
                Stake your tokens and let the interest of the staked money pay
                for your storage
              </div>
              <div className="home-content">
                Investorage aims to become a medium of DeFi where
                a user can stake some amount of tokens in a pool and gain not
                just interest for the staked tokens but a storage deal of their
                choice too
              </div>
              <div className="home-button-div" style={{ cursor: "pointer" }}>
                <div className="home-button">
                  <img
                    src={BtnImg}
                    // style={{ cursor: "pointer" }}
                    onClick={() => {
                      takeToPlayer();
                    }}
                  />
                </div>
                <div className="btn-text1">Signup</div>
                <div className="btn-arrow">
                  <img src={BtnArrow} />
                </div>
                <div className="btn-text2">Get started</div>
              </div>
            </div>

            <img className="home-line1" src={Line1} />
            <img className="home-top-img" src={TopBox} />
          </div>
        </section>

        <section>
          <img src={Line2} className="home-line2" />
        </section>

        <section className="home-bottom">
          <img className="home-btm-box1" src={Asset1} />

          <img className="home-btm-box2" src={Asset2} />
          <div className="home-btm-text">
            Let your Interest of your staked money pay for your storage.
            <br></br>
            <br></br>
            Get your staked money back in a year.
          </div>
          <div className="home-btm-imgs-main">
            <div className="home-btm-imgs-sub">
              <img className="home-btm-img" src={AAVE} />
              <img className="home-btm-img" src={Uni} />
              <img className="home-btm-img" src={compoundDao} />
            </div>
            <div className="home-btm-imgs-sub">
              {/* <img className="home-btm-img" src={AppleTV} /> */}
            </div>
          </div>
        </section>
        <section>
          <img className="home-line3" src={Line3} />
        </section>
      </div>
    </>
  );
};

export default Home;
