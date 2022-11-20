import React, { createContext } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import NavBar from "./components/Home and Navbar/navbar";
import Home from "./components/Home and Navbar/home";
import Profile from "./components/Signup and Profile/profile";
import SignUp from "./components/Signup and Profile/signup";
import Subscription from "./components/All Subscription/allsubscription";
import { WagmiConfig, createClient } from "wagmi";
import { getDefaultProvider } from "ethers";
import "./App.css";

const client = createClient({
  autoConnect: true,
  provider: getDefaultProvider(),
});

const App = () => {
  return (
    <div>
      <>
        <WagmiConfig client={client}>
          <Router>
            <NavBar />
            <div className="pages">
              <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/profile" element={<Profile />} />
                <Route path="/signup" element={<SignUp />} />
                <Route path="/subscription" element={<Subscription />} />
              </Routes>
            </div>
          </Router>
        </WagmiConfig>
      </>
      {/* <Footer /> */}
    </div>
  );
};

export default App;
